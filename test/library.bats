#!/usr/bin/env --split-string=bats/bin/bats --line-reference-format colon --trace --verbose-run
# SPDX-FileType: SOURCE
# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: © 2025 contributors
# SPDX-FileContributor: KlfJoat

load "$BATS_TEST_DIRNAME/bats_helpers/bats-support/load"
load "$BATS_TEST_DIRNAME/bats_helpers/bats-assert/load"

setup_file() {
  # Load the file that has the functions to be tested.
  source "$BATS_TEST_DIRNAME/../library.bash"
  # Reminder:  Functions need to be exported after sourcing to be visible in Bats.
  #            Put `export -f` lines after every function in the sourced file.
}


# Usage checks
@test "bash_versionnewerthan noarg fail" {
  run bash_versionnewerthan

  assert_failure 2
  assert_output '[bash_versionnewerthan] You passed no arguments or more than 3 arguments to test the bash version.'
}

@test "bash_versionnewerthan 1 blankarg fail" {
  run bash_versionnewerthan ''

  assert_failure 3
  assert_output '[bash_versionnewerthan] One or more arguments are not positive integers.'
}

# Non-numbers
@test "bash_versionnewerthan major alpha fail" {
  run bash_versionnewerthan 'a'

  assert_failure 3
  assert_output '[bash_versionnewerthan] One or more arguments are not positive integers.'

  run bash_versionnewerthan 'b' '2'

  assert_failure 3
  assert_output '[bash_versionnewerthan] One or more arguments are not positive integers.'

  run bash_versionnewerthan 'c' '2' '32'

  assert_failure 3
  assert_output '[bash_versionnewerthan] One or more arguments are not positive integers.'
}
@test "bash_versionnewerthan minor alpha fail" {
  run bash_versionnewerthan '5' 'd'

  assert_failure 3
  assert_output '[bash_versionnewerthan] One or more arguments are not positive integers.'

  run bash_versionnewerthan '5' 'e' '32'

  assert_failure 3
  assert_output '[bash_versionnewerthan] One or more arguments are not positive integers.'
}
@test "bash_versionnewerthan patch alpha fail" {
  run bash_versionnewerthan '5' '2' 'f'

  assert_failure 3
  assert_output '[bash_versionnewerthan] One or more arguments are not positive integers.'
}

### Old major versions (pass)
@test "bash_versionnewerthan 4.4.0 pass" {
  run bash_versionnewerthan '4' '4' '0'

  assert_success
  refute_output
}

### CURRENT version (pass)
@test "bash_versionnewerthan current pass" {
  run bash_versionnewerthan "${BASH_VERSINFO[0]}" "${BASH_VERSINFO[1]}" "${BASH_VERSINFO[2]}"

  assert_success
  refute_output
}

### Newer major versions (fail)
@test "bash_versionnewerthan 8.1.23 fail" {
  run bash_versionnewerthan '8' '1' '23'

  assert_failure 1
  assert_output --partial "This script requires a bash version 8.1.23 or newer."
}

@test "bash_versionnewerthan major 80 fail" {
  run bash_versionnewerthan '80'

  assert_failure 1
  assert_output --partial 'This script requires a bash version 80.0.0 or newer.'
}
