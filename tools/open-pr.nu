#!/usr/bin/env nu

source ./github.nu

def main [issue: number, branch: string] {
  let response = pull-issue $issue

  if (is-pr $response) {
    print --stderr $"Issue #($issue) is a pull request, not an issue."
    return
  }

  let is_submission = has-tag $response "submission"
  let is_edit = has-tag $response "edit"

  if not $is_submission and not $is_edit {
    print --stderr $"Issue #($issue) is not labeled as a submission or edit."
    return
  }

  if $is_submission and $is_edit {
    print --stderr $"Issue #($issue) is labeled as both a submission and an edit."
    return
  }

  let title = $response | get "title" | url encode
  let body = $"Closes #($issue)" | url encode
  let labels = if $is_submission { "submission" } else { "edit" } | url encode

  print $"Opening PR for branch '($branch)' in your browser..."

  start $"https://github.com/acearchive/artifact-submissions/compare/main...($branch)?quick_pull=1&title=($title)&body=($body)&labels=($labels)"
}
