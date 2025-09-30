# list recipes
default:
  @just --list

# pull a submission JSON by its issue number into the working tree
pull issue:
  ./tools/pull-issue.nu {{ issue }}

# open a PR for a submission
submit issue branch:
  ./tools/open-pr.nu {{ issue }} {{ branch }}

# upload a file to a bucket temporarily to get a direct download link
upload file:
  ./tools/upload-file.nu {{ file }}
