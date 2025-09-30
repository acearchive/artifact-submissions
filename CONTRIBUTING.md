# Contributing

This file contains instructions for code contributors.

## Approving submissions

This section outlines the process for approving submissions to the archive.

As a prerequisite, you will need to install:

- [just](https://github.com/casey/just?tab=readme-ov-file#installation)
- [Nu](https://www.nushell.sh/book/installation.html)

Submissions take the form of GitHub issues. To add a submission to the archive:

1. Run `just pull <issue_number>` to pull the artifact metadata into your
   working tree.
2. Make any changes you deem necessary to the user's submission by hand.
3. Commit the file and push to a new branch.
4. Run `just submit <issue_number> <branch_name>` to open a PR.
5. An automation will run to validate the artifact metadata. Wait for that to
   complete.
6. Once the automation completes, visit each of the URLs of files in the
   submission to validate they're direct download links and haven't changed or
   been deleted since the user created the submission.
7. Merge the PR. This will upload the files and add the artifact to the archive.

## Technical details

A CI job validates the contents of the JSON file. It also calculates the hash
and media type of each file in the submission and generates a random artifact ID
for the artifact. These changes are committed back to the branch by a bot.

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

## Manually dispatching workflows

The CI workflow only validates/uploads submission files which are different from
the parent commit. That's how we determine whether an artifact submission has
changed and needs to be reuploaded. Typically, this should work fine.

However, if you ever need to run one of the workflows manually, you have to
remember that it will only affect files modified since the parent commit. If you
need to bypass this restriction, you can specify the base ref to diff against
when you trigger a workflow via `workflow_dispatch`. You'll be prompted with a
dialog, where the default base ref is `HEAD~1`.
