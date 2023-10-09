# artifact-submissions

This repository is where submissions to add or modify artifacts in [Ace
Archive](https://acearchive.lgbt) are collected for manual review. Want to
submit an artifact to the archive? [Fill out this
form](https://acearchive.lgbt/submit) on the website.

Each submission is a JSON file in the [submissions/](./submissions/) directory
which is generated by a form on Ace Archive. That form redirects users here to
open an issue, passing JSON body as a query parameter. Then a team member can
open a PR to add that submission to the repo.

When a PR is opened,
[acearchive/artifact-submit-action](https://github.com/acearchive/artifact-submit-action)
validates that the artifact submission JSON matches the expected schema. This
action also downloads any files referenced in the submission to determine their
media type and calculate their hash, and then a bot adds those fields to the
JSON file and commits the changes to the branch.

This bot will not attempt to overwrite existing file hashes or media types, so
team members can manually edit the JSON if necessary without the bot overwriting
their changes. Likewise, team members can delete the file hash or media type
fields to have the bot recalculate them.

When a PR is approved, the action downloads the files, re-hashes them to verify
that the contents at the URL haven't changed, and then uploads them to Ace
Archive.

Additionally,
[acearchive/hugo-artifact-action](https://github.com/acearchive/hugo-artifact-action)
is used to automatically generate static assets from the artifact submissions
which are used to build the static site.

We may periodically need to change the format of these submission files. The
[migrations/](./migrations/) directory contains scripts used to migrate
submission files from one version to the next. Each submission file contains a
top-level `version` key which indicates the current version.
