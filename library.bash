#!/bin/false
# shellcheck shell=bash   # I don't want this executable
# SPDX-FileType: SOURCE
# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: © 2025 contributors
# SPDX-FileContributor: KlfJoat


# @description Bash version minimum
# Test if current bash version is newer than the one specified.
# @example
#     if [[ bash_versionnewerthan 4 1 ]]; then...
#
# @arg $1 integer Major version number
# @arg $2 integer Minor version number (optional)
# @arg $3 integer Patch version number (optional)
# @exitcode 0 Version is newer or equal to the arguments
# @exitcode 1 Version is older than the arguments
# @exitcode 2 Insufficient number of arguments (fatal bc bad usage)
# @exitcode 3 Arguments are not all positive integers (fatal bc bad usage)
# @stderr Message if version is older or if no arguments passed in.
# @test test/stdlib.bats
bash_versionnewerthan() {
  if [[ $# -eq 0 ]] || [[ $# -gt 3 ]]; then
    printf '[%s] %s\n' "${FUNCNAME[0]}" 'You passed no arguments or more than 3 arguments to test the bash version.' >&2
    exit 2
  fi

  local major minor patch
  # If someone can sneak a '' through for major, the base10 casting below finds it.
  major=${1}
  # If not passed or blank, assume 0 for minor and patch numbers.
  minor=${2:-0}
  patch=${3:-0}

  # Use bash base10 casting to throw an error (implicit false) if not a number or negative or blank (only for major)
  if ! (( 10#${major} >= 0 || 10#${minor} >= 0 || 10#${patch} >= 0 )) 2>/dev/null ; then
    printf '[%s] %s\n' "${FUNCNAME[0]}" 'One or more arguments are not positive integers.' >&2
    exit 3
  fi

  # Quick pass if major or minor are > current.
  if (( BASH_VERSINFO[0] > major )); then return 0
  elif (( BASH_VERSINFO[0] == major )); then
    if (( BASH_VERSINFO[1] > minor )); then return 0
    elif (( BASH_VERSINFO[1] == minor )); then
      if (( BASH_VERSINFO[2] >= patch )); then
        return 0
      fi
    fi
  fi

  printf '%s %s.%s.%s %s\n' 'This script requires a bash version' "${major}" "${minor}" "${patch}" 'or newer.' >&2
  printf "%s  '%s'\n" 'Your bash version is' "${BASH_VERSION}" >&2
  return 1
}
export -f bash_versionnewerthan
