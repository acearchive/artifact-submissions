#!/usr/bin/env nu

def pull-issue [issue: number] {
  http get $"https://api.github.com/repos/acearchive/artifact-submissions/issues/($issue)" -H {
    "Accept": "application/vnd.github.markdown+json"
    "X-GitHub-Api-Version": "2022-11-28"
  }
}

def is-pr [response: any] {
  ($response | columns | where $it == "pull_request" | length) > 0
}

def has-tag [response: any, tag: string] {
  ($response | get "labels" | where $it.name == $tag | length) > 0
}
