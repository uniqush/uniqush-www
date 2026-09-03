#!/usr/bin/env python3
"""Pull the operator-facing docs out of a uniqush-push checkout and turn them
into content pages here, so the site can't drift from what the code actually
does. Run before `hugo build`, locally and in CI:

    python3 scripts/import-docs.py /path/to/uniqush-push

The three files this produces are .gitignored -- they're always regenerated,
never hand-edited. If uniqush-push's docs/api.md or docs/upgrading.md add a
relative link this script doesn't know about, LINK_MAP below needs a new
entry, or the link will point at a dead .md file on the live site.
"""
import re
import sys
from pathlib import Path

REPO_BLOB = "https://github.com/uniqush/uniqush-push/blob/master/"
REPO_TREE = "https://github.com/uniqush/uniqush-push/tree/master/"

# Relative link targets found in uniqush-push's docs/*.md, mapped to where
# they should point from this site instead.
LINK_MAP = {
    "upgrading.md": "/documentation/upgrading.html",
    "upgrading.md#fcm": "/documentation/upgrading.html#fcm",
    "docs/upgrading.md": "/documentation/upgrading.html",
    "api.md": "/documentation/usage.html",
    "../NEWS.md": REPO_BLOB + "NEWS.md",
    "apns-verification-plan.md": REPO_BLOB + "docs/apns-verification-plan.md",
    "apns-verification-plan.md#token-p8-authentication": REPO_BLOB + "docs/apns-verification-plan.md#token-p8-authentication",
    "adr/0001-deterministic-apns-provider-tokens.md": REPO_BLOB + "docs/adr/0001-deterministic-apns-provider-tokens.md",
    "delivery-point-rebinding.md": REPO_BLOB + "docs/delivery-point-rebinding.md",
    "../README.md#apns": "https://github.com/uniqush/uniqush-push#apns",
    "../README.md#unifiedpush--web-push": "https://github.com/uniqush/uniqush-push#unifiedpush--web-push",
    "../examples/fcm-demo": REPO_TREE + "examples/fcm-demo",
    "conf/uniqush-push.conf": REPO_BLOB + "conf/uniqush-push.conf",
}

LINK_RE = re.compile(r"\]\(([^)\s]+)\)")


def rewrite_links(text: str) -> str:
    def repl(m):
        target = m.group(1)
        return "](" + LINK_MAP.get(target, target) + ")"
    return LINK_RE.sub(repl, text)


def demote_headings(text: str) -> str:
    """Add one '#' to every ATX heading outside a fenced code block, since the
    page template already renders the front-matter title as the H1."""
    out = []
    in_fence = False
    for line in text.splitlines():
        if line.lstrip().startswith("```"):
            in_fence = not in_fence
            out.append(line)
            continue
        if not in_fence and re.match(r"^#{1,5} ", line):
            out.append("#" + line)
        else:
            out.append(line)
    return "\n".join(out) + "\n"


def strip_leading_h1(text: str) -> str:
    lines = text.splitlines()
    if lines and lines[0].startswith("# "):
        lines = lines[1:]
        while lines and lines[0].strip() == "":
            lines = lines[1:]
    return "\n".join(lines) + "\n"


def write_page(out_path: Path, front_matter: str, body: str) -> None:
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(f"---\n{front_matter}---\n{body}")
    print(f"wrote {out_path}")


def import_simple(src: Path, out_path: Path, title: str, extra_front_matter: str = "") -> None:
    body = src.read_text()
    body = strip_leading_h1(body)
    body = demote_headings(body)
    body = rewrite_links(body)
    front_matter = f'title: "{title}"\n{extra_front_matter}'
    write_page(out_path, front_matter, body)


def import_unreleased_news(src: Path, out_path: Path) -> None:
    text = src.read_text()
    # Everything between the "Unreleased" heading and the next dated release
    # heading (a line of dashes underlines "Unreleased"; the next section is
    # introduced the same way).
    lines = text.splitlines()
    try:
        start = next(i for i, l in enumerate(lines) if l.strip() == "Unreleased") + 2
    except StopIteration:
        print("NEWS.md has no 'Unreleased' section; skipping", file=sys.stderr)
        return
    end = start
    while end < len(lines) and not re.match(r"^\d{1,2} \w+ \d{4}, uniqush-push", lines[end]):
        end += 1
    body = "\n".join(lines[start:end]).strip() + "\n"
    body = demote_headings(rewrite_links(body))
    front_matter = (
        'title: "Unreleased"\n'
        "weight: -100000\n"
        'params:\n  summary: "What is in master, not yet a tagged release"\n'
    )
    write_page(out_path, front_matter, body)


def main():
    if len(sys.argv) != 2:
        print(f"usage: {sys.argv[0]} /path/to/uniqush-push", file=sys.stderr)
        sys.exit(1)
    push_dir = Path(sys.argv[1])
    site_dir = Path(__file__).resolve().parent.parent
    content = site_dir / "content"

    import_simple(
        push_dir / "docs" / "api.md",
        content / "documentation" / "usage.md",
        "Using Uniqush",
        "aliases:\n  - /wiki/UniqushAPIs/index.html\n",
    )
    import_simple(
        push_dir / "docs" / "upgrading.md",
        content / "documentation" / "upgrading.md",
        "Upgrading from 2.7.0",
    )
    import_unreleased_news(
        push_dir / "NEWS.md",
        content / "release-notes" / "unreleased.md",
    )


if __name__ == "__main__":
    main()
