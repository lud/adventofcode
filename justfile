play:
  mix aoc.create | rg '\.ex' | rg -v Compiling | xargs code
  mix format
  firefox $(mix aoc.url | rg "https")

benchmark:
  mix aoc.run -b

repo:
  firefox https://github.com/lud/adventofcode/