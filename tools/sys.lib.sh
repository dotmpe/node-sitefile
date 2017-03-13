#!/bin/sh

# Sys: lower level Sh helpers; dealing with vars, functions, and other shell
# ideosyncracities

set -e



sys_load()
{
  test -n "$SCR_SYS_SH" ||  {
    test -n "$SHELL" &&
    SCR_SYS_SH="$(basename "$SHELL")" ||
    SCR_SYS_SH=bash
  }
}


# test for var decl, io. to no override empty
var_isset()
{
  test -n "$1" || error "var-isset arg expected" 1
  # [2017-02-03] somehow Sh compatible setup broke so (testing at least) so
  #   split it up into bash, and expanded on testing. And some more testing and
  #   fiddling. Using SCR_SYS_SH=bash-sh to make some frontend exceptions.
  case "$SCR_SYS_SH" in

    bash-sh|sh )
        # Aside from declare or typeset in newer reincarnations,
        # in posix or modern Bourne mode this seems to work best:
        ( set | grep -q '\<'$1'=' ) || return 1
      ;;

    bash )
        # Bash: https://www.cyberciti.biz/faq/linux-unix-howto-check-if-bash-variable-defined-not/
        $scriptdir/sh/var-isset.bash "$1" || return 1
      ;;

    * )
        error "SCR_SYS_SH='$SCR_SYS_SH'" 12
      ;;

  esac
}

# require vars to be initialized, regardless of value
req_vars()
{
  while test $# -gt 0
  do
    var_isset "$1" || return 1
    shift
  done
}

# No-Op(eration)
noop()
{
  #. /dev/null # source empty file
  #echo -n # echo nothing
  #printf "" # id. if echo -n incompatible (Darwin)
  set -- # clear arguments (XXX set nothing?)
	#return # since we're in a function
}

trueish()
{
  test -n "$1" || return 1
  case "$1" in
		[Oo]n|[Tt]rue|[Yyj]|[Yy]es|1)
      return 0;;
    * )
      return 1;;
  esac
}

falseish()
{
  test -n "$1" || return 1
  case "$1" in
		[Oo]ff|[Ff]alse|[Nn]|[Nn]o|0)
      return 0;;
    * )
      return 1;;
  esac
}

cmd_exists()
{
  test -x $(which $1) || return $?
}

func_exists()
{
  type $1 2> /dev/null 1> /dev/null || return $?
  # XXX bash/bsd-darwin: test "$(type -t $1)" = "function" && return
  return 0
}

try_exec_func()
{
  test -n "$1" || return 97
  func_exists $1 || return $?
  local func=$1
  shift 1
  $func "$@" || return $?
}

try_var()
{
  local value="$(eval echo "\$$1")"
  test -n "$value" || return 1
  echo $value
}

# Id: node-sitefile/0.0.6-dev tools/sys.lib.sh
