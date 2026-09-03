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

The three generated pages (`content/documentation/usage.md`, `content/documentation/upgrading.md`, `content/release-notes/unreleased.md`) are gitignored -- never hand-edit them, they're overwritten on the next `import-docs.py` run. If uniqush-push's `docs/api.md` or `docs/upgrading.md` add a relative link the script doesn't know how to rewrite, `scripts/import-docs.py`'s `LINK_MAP` needs a new entry.

The blog isn't built by this repo. To see it locally, build it separately from a uniqush-blog checkout and copy its output into `public/blog/` after running `hugo`.

Deployment
----------

`.github/workflows/deploy.yml` builds and publishes the site with GitHub Actions (`actions/deploy-pages`), on a push to `master`, on a `repository_dispatch` from uniqush-push or uniqush-blog when their content changes, on a weekly schedule as a safety net, and on demand.

**One manual step is required in the GitHub repo settings and can't be done from here:** under Settings -> Pages, the source needs to be switched from "Deploy from a branch" (the old `gh-pages` branch) to "GitHub Actions". Until that's flipped, pushes to this branch won't actually publish.

The `repository_dispatch` triggers also need a `WWW_DISPATCH_TOKEN` secret (a PAT with permission to dispatch to this repo) added to the uniqush-push and uniqush-blog repos' own settings -- the workflow files for that are prepared but need that secret before the dispatch step will work. Until it's set up, the weekly schedule and manual `workflow_dispatch` still cover it.

URLs
----

`hugo.toml` sets `uglyURLs = true` so every path from the old webgen site keeps working (`/documentation/intro.html`, not `/documentation/intro/`). Retired wiki pages redirect via `aliases:` in their front matter -- see `content/documentation/usage.md`'s (generated) alias to `/wiki/UniqushAPIs/index.html` for an example, and note that an alias ending in a directory needs its target to end in `/index.html` explicitly, or Hugo's `uglyURLs` setting flattens it into a broken `.html` file instead of an `index.html` under that directory.
