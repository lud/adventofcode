play:
  mix aoc.create | rg '\.ex' | xargs code
  firefox $(mix aoc.url | rg "https")
