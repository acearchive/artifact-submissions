# Contributing

This file contains instructions for code contributors.

## Approving Submissions

This section outlines the process for approving submissions to the archive.

Submissions take the form of GitHub issues with the artifact metadata JSON in
the body. If the user is submitting a new artifact, it will have the
`submission` label and the title will start with `[Submission]`. If the user is
editing an existing artifact, it will have the `edit` label and the title will
start with `[Edit]`.

To add a submission to the archive, you need to check it into this repo as a
JSON file under the [`submissions/`](./submissions/) directory. At this point,
you can make any changes you deem necessary to the user's submission by hand.
The name of the JSON file should be the artifact slug. You should open a PR with
the change; do not commit directly to `main`.

The PR title should start with `[Submission]` or `[Edit]`. Link to the issue
number in the PR body.

A CI job will validate the contents of the JSON file. It will also calculate the
hash and media type of each file in the submission and generate a random
artifact ID for the artifact. These changes are committed back to the branch by
a bot.

If you need to change the media type or hash of a file by hand, the CI job will
not overwrite your changes. If you need the CI job to regenerate those fields,
just delete them from the JSON and wait for the CI job to run again. If you for
some reason need to edit the file hash by hand, remember that the file hash is
encoded as a [multihash](https://multiformats.io/multihash/).

Once the CI job finishes validating the submission and generating the necessary
fields, it's important that you follow each of the URLs of files in the
submission to make sure they point where you expect them to. The idea is to make
sure the links are direct download links and not web pages, the files haven't
been deleted since the user created the submission, the files aren't malicious,
etc. When you merge the PR, a second CI job will compare the hash again before
uploading it to Ace Archive to make sure the file hasn't changed out from under
you since you manually reviewed it. You want to do this review after the
validation job (which calculates the hash) runs but before you merge the PR so
that you can be sure the file doesn't change out from under you.

Once your PR in this repo is merged, the artifact will be returned by the Ace
Archive API, but will not yet appear on the website. To make the artifact appear
on the site, you need to check out the
[acearchive/acearchive.lgbt](https://github.com/acearchive/acearchive.lgbt) repo
and run:

```shell
hugo mod get github.com/acearchive/hugo-artifacts
```

This will update the `go.mod` and `go.sum` files. You can then commit these
changes to the repo. Committing this change directly to `main` is probably safe,
although you may want to check out what the artifact page will look like on the
site first by using `npm run server` to spin up a local instance of the site.

## Manually Dispatching Workflows

The CI workflow only validates/uploads submission files which are different from
the parent commit. That's how we determine whether an artifact submission has
changed and needs to be reuploaded. Typically, this should work fine.

However, if you ever need to run one of the workflows manually, you have to
remember that it will only affect files modified since the parent commit. If you
need to bypass this restriction, you can specify the base ref to diff against
when you trigger a workflow via `workflow_dispatch`. You'll be prompted with a
dialog, where the default base ref is `HEAD~1`.
