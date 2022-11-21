# artifact-submissions

🚧 This repository is under construction. 🚧

This repository is where submissions to add or modify artifacts in [Ace
Archive](https://acearchive.lgbt) are collected for manual review.

Each submission is a JSON file in the [submissions/](./submissions/) directory
generated by a form on Ace Archive.

When a PR is opened, the GitHub Action in
[acearchive/artifact-submit-action](https://github.com/acearchive/artifact-submit-action)
validates that the JSON submission files match the expected schema. If any files
do not have a file hash or a media type in their submission, they are added (by
downloading the file at the provided URL) and those changes are committed.

When a PR is merged, that same action uploads the linked files to Ace Archive.
Additionally,
[acearchive/hugo-artifact-action](https://github.com/acearchive/hugo-artifact-action)
is used to automatically generate static assets from the artifact submissions
which are used to build the static site.
