This repository contains the content and templates for [uniqush.org](https://uniqush.org). We use [Hugo](https://gohugo.io/) to generate the site (webgen, the old Ruby-based generator, is gone as of the Hugo migration -- see git history if you need it).

The blog at [uniqush.org/blog/](https://uniqush.org/blog/) is a separate site, built from [uniqush-blog](https://github.com/uniqush/uniqush-blog) with Pelican, and folded into this site's output at deploy time.

Building locally
-----------------

You'll need [Hugo](https://gohugo.io/installation/) (0.165.0 is what CI pins; `extended` is not required) and a checkout of [uniqush-push](https://github.com/uniqush/uniqush-push), since three pages here (the API reference, the upgrade guide, and the "Unreleased" changelog entry) are generated from that repo's docs rather than hand-written -- this keeps the site from drifting out of sync with what the code actually does.

```bash
python3 scripts/import-docs.py /path/to/uniqush-push
hugo server   # http://localhost:1313, or...
hugo --minify # ...to build the static site into ./public
```

The three generated pages (`content/documentation/usage.md`, `content/documentation/upgrading.md`, `content/release-notes/unreleased.md`) are gitignored -- never hand-edit them, they're overwritten on the next `import-docs.py` run. If uniqush-push's docs add a relative link to a page the script doesn't know how to rewrite, the script exits non-zero and names the link, so a deploy stops rather than publishing a dead link; add the page to `scripts/import-docs.py`'s `LINK_MAP`. A link to a section (`api.md#stats`) needs no entry of its own once its page has one.

The blog isn't built by this repo. To see it locally, build it separately from a uniqush-blog checkout and copy its output into `public/blog/` after running `hugo`.

Deployment
----------

`.github/workflows/deploy.yml` builds and publishes the site with GitHub Actions (`actions/deploy-pages`), on a push to `master`, on a `repository_dispatch` from uniqush-push when its docs change, on a weekly schedule as a safety net, and on demand.

**One manual step is required in the GitHub repo settings and can't be done from here:** under Settings -> Pages, the source needs to be switched from "Deploy from a branch" (the old `gh-pages` branch) to "GitHub Actions". Until that's flipped, pushes to this branch won't actually publish.

The `repository_dispatch` from uniqush-push is sent by its `notify-www.yml` workflow, which needs a `WWW_DISPATCH_TOKEN` secret in uniqush-push's settings: a fine-grained PAT with access to this repo and "Contents: Read and write" (that workflow's header has the details). Without it, that workflow fails with an error saying so. uniqush-blog has no such workflow yet, so a new blog post reaches the site on the next push here, the weekly run, or a manual `workflow_dispatch`; the `blog-updated` dispatch type is accepted for when it does.

URLs
----

`hugo.toml` sets `uglyURLs = true` so every path from the old webgen site keeps working (`/documentation/intro.html`, not `/documentation/intro/`). Retired wiki pages redirect via `aliases:` in their front matter -- see `content/documentation/usage.md`'s (generated) alias to `/wiki/UniqushAPIs/index.html` for an example, and note that an alias ending in a directory needs its target to end in `/index.html` explicitly, or Hugo's `uglyURLs` setting flattens it into a broken `.html` file instead of an `index.html` under that directory.
