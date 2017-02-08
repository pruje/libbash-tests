# core basic tests

# command exists
tb_test lb_command_exists echo Hello world!
tb_test -c 1 lb_command_exists
tb_test -c 2 lb_command_exists notAcommand


# function exists
tb_test lb_function_exists lb_yesno
tb_test -c 1 lb_function_exists
tb_test -c 2 lb_function_exists notAfunction
tb_test -c 3 lb_function_exists echo


# test arguments
tb_test -c 1 lb_test_arguments falseOperator
tb_test -c 2 lb_test_arguments -eq 0 Hello world
tb_test lb_test_arguments -eq 2 Hello world
tb_test lb_test_arguments -le 2 Hello world
tb_test lb_test_arguments -lt 3 Hello world
tb_test lb_test_arguments -ge 2 Hello world
tb_test lb_test_arguments -gt 1 Hello world

# avoid skipping tests if last failed
return 0
