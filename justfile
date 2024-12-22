play:
  mix aoc.create | rg '\.ex' | rg -v Compiling | xargs code
  mix format
  nohup firefox $(mix aoc.url | rg "https") >/dev/null 2>&1 &
  echo 'Good Luck :)'

benchmark *args:
  mix aoc.run -b {{args}}

repo:
  nohup firefox https://github.com/lud/adventofcode/ >/dev/null 2>&1 &