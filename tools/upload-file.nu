#!/usr/bin/env nu

def main [file: string] {
  let filename = $file | path basename
  let url = $"https://pub-298bc938d7aa4d348b4556cf3caf11bd.r2.dev/($filename)"

  npx wrangler@latest r2 object put $"acearchive-lgbt-staging/($filename)" --remote --file $file

  print $"File URL: ($url)"
}
