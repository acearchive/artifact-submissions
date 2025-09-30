#!/usr/bin/env nu

def main [issue: number] {
  let response = http get $"https://api.github.com/repos/acearchive/artifact-submissions/issues/($issue)" -H {
    "Accept": "application/vnd.github.markdown+json"
    "X-GitHub-Api-Version": "2022-11-28"
  }

  let is_pr = ($response | columns | where $it == "pull_request" | length) > 0

  if $is_pr {
    print --stderr $"Issue #($issue) is a pull request, not an issue."
    return
  }

  let is_submission = ($response | get "labels" | where $it.name == "submission" | length) > 0
  let is_edit = ($response | get "labels" | where $it.name == "edit" | length) > 0

  if not $is_submission and not $is_edit {
    print --stderr $"Issue #($issue) is not labeled as a submission or edit."
    return
  }

  let body = $response.body
  let start_line = $body | lines | enumerate | where $it.item == "```JSON" | get "index" | first
  let end_line = $body | lines | enumerate | where $it.item == "```" | get "index" | first
  let submission = $body | lines | slice ($start_line + 1)..($end_line - 1) | str join "" | from json
  let filename = $"submissions/($submission.slug).json"

  $submission | to json --indent 2 | save $filename

  print $"Submission JSON pulled as ($filename)"
}
