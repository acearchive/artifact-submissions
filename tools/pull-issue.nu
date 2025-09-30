#!/usr/bin/env nu

source ./github.nu

def main [issue: number] {
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

  let body = $response.body
  let start_line = $body | lines | enumerate | where $it.item == "```JSON" | get "index" | first
  let end_line = $body | lines | enumerate | where $it.item == "```" and $it.index > $start_line | get "index" | first
  let submission = $body | lines | slice ($start_line + 1)..($end_line - 1) | str join "" | from json
  let filename = $"submissions/($submission.slug).json"

  $submission | to json --indent 2 | save $filename

  print $"Submission JSON pulled as ($filename)"
}
