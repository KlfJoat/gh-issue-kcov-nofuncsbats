# Issue Text SimonKagstrom/kcov#476

I'm running `kcov` on a few different repos of Bash scripts where I have extensive Bats test suites. I'd like to use it with the VSC extension Coverage Gutters.

In these repos, I make heavy use of Bash functions. But I'm running into a problem where it seems like my extensive use of functions somehow hides the code from `kcov`.

I have uploaded a runnable example at the following repo:  https://github.com/KlfJoat/gh-issue-kcov-nofuncsbats

Versions of relevant programs

* `kcov` - `v43-21-g30d3` (self-compiled)
* `bash` - `5.2.32(1)-release` (Ubuntu 24.10)
* `Bats` - `1.12.0` (latest)

I've tried with both default (which I think uses PS4) and `--bash-method=DEBUG`. DEBUG hides all results from me and never shows anything on the screen.

## What I run

```shell
kcov --cobertura-only --include-path=. --exclude-path=test,coverage --clean coverage test/bats/bin/bats --verbose-run test/*.bats
```

## Expected Output

A `cov.xml` file that shows any code in the function has been executed at least once.

## Actual Output

#### On `stdout`

```text
1..9
ok 1 bash_versionnewerthan noarg fail
ok 2 bash_versionnewerthan 1 blankarg fail
ok 3 bash_versionnewerthan major alpha fail
ok 4 bash_versionnewerthan minor alpha fail
ok 5 bash_versionnewerthan patch alpha fail
ok 6 bash_versionnewerthan 4.4.0 pass
ok 7 bash_versionnewerthan current pass
Your bash version is  '5.2.32(1)-release' ]]
Your bash version is  '5.2.32(1)-release' != *\T\h\i\s\ \s\c\r\i\p\t\ \r\e\q\u\i\r\e\s\ \a\ \b\a\s\h\ \v\e\r\s\i\o\n\ \8\.\1\.\2\3\ \o\r\ \n\e\w\e\r\.* ]]
ok 8 bash_versionnewerthan 8.1.23 fail
Your bash version is  '5.2.32(1)-release' ]]
Your bash version is  '5.2.32(1)-release' != *\T\h\i\s\ \s\c\r\i\p\t\ \r\e\q\u\i\r\e\s\ \a\ \b\a\s\h\ \v\e\r\s\i\o\n\ \8\0\.\0\.\0\ \o\r\ \n\e\w\e\r\.* ]]
ok 9 bash_versionnewerthan major 80 fail
```

(the random output besides TAP seems to be Bats interacting with kcov; it's not there when I run straight Bats)

#### In [`coverage/cov.xml`](coverage/cov.xml)

No tracking of the execution of the function, despite `stdout` clearly showing the test executed successfully.

Every line shows 0 hits except for the `export -f` where I make the function visible to Bats.
