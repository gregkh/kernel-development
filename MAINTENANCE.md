# Maintenance notes

Notes on keeping this repository healthy.  Nothing here changes the content of
the slide decks - the decks, images and statistics are left exactly as they
are.  See [`README`](README) for what the presentation is and how it is
licensed.

## Repository layout

| Path | What it is |
| --- | --- |
| `kernel-development-how-and-security.odp` | Newest and largest variant (95 slides, 2026). Start here. |
| `kernel-development{,-16x9,-wide}.odp` | The main deck in 4:3, 16:9 and 16:10 layouts. |
| `kernel-git.odp`, `lf_*.odp`, `linaro.odp`, `kernel-summit.odp` | Focused variants for specific audiences. |
| `*.pdf`, `*_notes.pdf` | Exported copies of the decks (see "Stale exports" below). |
| `images/` | Artwork embedded by the decks (`kernel_patch_process.svg`, `release_cycle.svg`, ...). |
| `graphs/` | Graphs used on the slides: `.graph` sources (gnuplot) plus rendered `.jpg`/`.pdf`. |
| `graphs/patches_per_release/` | Ruby/Gruff generators for the per-release graphs - see `NOTES` in that directory. |
| `poster/` | Perl scripts and `dot` graphs behind the 2006/2007 developer-graph posters. |
| `old/` | Historical, per-conference copies. Intentionally duplicated; treat as an archive. |
| `scripts/check_repo.py` | Repository checker described below. |

`old/` and `poster/` are historical snapshots.  Leave the files there
byte-for-byte, duplicate images and all.

## Checking the repository

```sh
python3 scripts/check_repo.py             # problems only fail; warnings are advisory
python3 scripts/check_repo.py --quiet     # print only problems
python3 scripts/check_repo.py --strict    # warnings fail too (use for local cleanups)
```

The script is read-only and uses nothing but the Python 3 standard library.
It verifies:

* every `.odp` is a readable zip, has a stored `mimetype` as its first entry,
  contains a well-formed `content.xml`, and every file listed in
  `META-INF/manifest.xml` really exists in the archive
* every `.pdf` has a `%PDF-` header and an `%%EOF` trailer (i.e. is not
  truncated), and how many pages it has
* PDF exports still match the slide count of their deck
* every Perl script compiles (`perl -c`) and every Ruby script parses
  (`ruby -c`, skipped when Ruby is not installed)
* no LibreOffice lock files or build artifacts are committed
* generated scratch output (`my_fruity_graph.png`, `.bundle/`, `__pycache__`)
  is covered by `.gitignore`
* no unexpected duplicate files, no empty files, and a text-hygiene pass

A ready-to-enable GitHub Actions workflow lives in
`docs/workflows/verify.yml`.  It is kept outside `.github/` on purpose, because
adding a file under `.github/workflows/` needs the `workflows` permission that
integration apps usually do not have.  To turn CI on:

```sh
mkdir -p .github/workflows
cp docs/workflows/verify.yml .github/workflows/verify.yml
git add .github/workflows/verify.yml && git commit -m "Enable repository checks"
```

The workflow runs the checker on every push and pull request, and separately
parses the Ruby graph scripts with `ruby -c` (Ruby is not needed locally, and
the checker simply skips that step when Ruby is missing).

## Known warnings

These are expected and need no action; they are reported so nothing important
is hidden between them.

### Stale PDF exports

The decks have grown since their PDFs were exported, so the committed exports
lag behind the `.odp` files.  Only the exports are out of date - the decks
themselves are intact.

| Deck | Slides | PDF pages | Exported |
| --- | --- | --- | --- |
| `kernel-git.odp` | 53 | 22 | 2016-04-03 |
| `kernel-development-16x9.odp` | 61 | 44 | 2016-05-09 |
| `kernel-development.odp` | 61 | 43 | 2018-05-22 |
| `kernel-development-wide.odp` | 69 | 39 | 2021-03-31 |
| `kernel-development-how-and-security.odp` | 95 | 82 | 2026 |
| `lf_kernel-development.odp` | 47 | 25 | 2014-11-10 |
| `lf_testing.odp` | 7 | 7 | in sync |

To refresh one (requires LibreOffice):

```sh
soffice --headless --convert-to pdf --outdir . kernel-development.odp
```

`kernel-summit.odp` and `linaro.odp` have no PDF export at all.

### Other standing warnings

* `old/` holds many identical copies of the same graphs and stock images - one
  copy per conference directory.  Intentional; the checker reports the count
  and moves on.
* The `.graph` files (gnuplot data) and a few historical files have no trailing
  newline or some trailing whitespace.  They are data/archive files, so they
  are left untouched.
* `graphs/lines_of_and_files_code.graph` and `graphs/lines_of_code.graph` are
  identical.  Both names are kept because older decks may refer to either.

## Working rules

* **Do** commit the generated graph PNGs in `graphs/patches_per_release/` - the
  decks embed them directly.
* **Do not** commit LibreOffice lock files (`.~lock.*#`), bundler state
  (`.bundle/`), or scratch output such as `my_fruity_graph.png`; all of these
  are git-ignored.
* When a deck changes, re-export its PDF and commit the export alongside it.
* The repository is large (~378 MB) mainly because of `poster/*.png` (the
  2006/2007 developer graphs, up to 21 MB each) and the embedded fonts in
  `kernel-development-how-and-security.odp`.  Please keep new assets small.
* Add large new binaries only if they are really needed - there is no Git LFS
  set up here.
