# core basic tests

# command exists
tb_test lb_command_exists echo
tb_test lb_command_exists echo true
tb_test -c 1 lb_command_exists echo notAcommand
tb_test -c 1 lb_command_exists notAcommand


# function exists
tb_test lb_function_exists lb_command_exists
tb_test lb_function_exists lb_command_exists lb_function_exists
tb_test -c 1 lb_function_exists
tb_test -c 2 lb_function_exists notAfunction
tb_test -c 3 lb_function_exists echo
tb_test -c 3 lb_function_exists lb_command_exists echo


# test arguments
tb_test -c 1 lb_test_arguments falseOperator
tb_test -c 2 lb_test_arguments -eq 0 Hello world
tb_test lb_test_arguments -eq 2 Hello world
tb_test lb_test_arguments -le 2 Hello world
tb_test lb_test_arguments -lt 3 Hello world
tb_test lb_test_arguments -ge 2 Hello world
tb_test lb_test_arguments -gt 1 Hello world


# get arguments
getargs() {
	lb_getargs "$@" || return 1
	echo ${lb_getargs[*]}
}
tb_test -c 1 getargs
tb_test -r "--opt arg" getargs --opt arg
tb_test -r "-a -b arg" getargs -ab arg


# get option
tb_test -c 1 lb_getopt
tb_test -c 1 lb_getopt --opt
tb_test -c 1 lb_getopt --opt --opt2
tb_test -r value lb_getopt --opt value
tb_test -r value2 lb_getopt --opt2=value2


# avoid skipping tests if last failed
return 0
