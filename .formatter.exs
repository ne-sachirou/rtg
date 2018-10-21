[
  import_deps: [:phoenix],
  inputs: [
    "*.exs",
    "{config,rel}/**/*.{ex,exs}",
    "apps/*/mix.exs",
    "apps/*/{config,lib,test}/**/*.{ex,exs}"
  ],
  export: [
    line_length: 120,
    locals_without_parens: []
  ]
]
