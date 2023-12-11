play:
  mix aoc.create | rg '\.ex' | rg -v Compiling | xargs code
  firefox $(mix aoc.url | rg "https")

benchmark:
  mix aoc.run -b