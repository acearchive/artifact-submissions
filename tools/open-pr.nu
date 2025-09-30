#!/usr/bin/env nu

def main [issue: number, branch: string] {
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

  if $is_submission and $is_edit {
    print --stderr $"Issue #($issue) is labeled as both submission and edit."
    return
  }

  let title = $response | get "title" | url encode
  let body = $"Closes #($issue)" | url encode
  let labels = if $is_submission { "submission" } else { "edit" } | url encode

  start $"https://github.com/acearchive/artifact-submissions/compare/main...($branch)?quick_pull=1&title=($title)&body=($body)&labels=($labels)"
}
