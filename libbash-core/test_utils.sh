# core utils tests

# detect os
tb_test lb_current_os
tb_test lb_detect_os


# test if a user exists
tb_test -c 1 lb_user_exists
tb_test -c 2 lb_user_exists badUserName
tb_test lb_user_exists $(whoami)


# test if a user is in a group
tb_test -c 1 lb_in_group
tb_test -c 3 lb_in_group group badUserName
tb_test -c 2 lb_in_group badGroupName
# test with getting the first group of current user
test_groups=($(groups))
tb_test lb_in_group $test_groups $(whoami)


# generate password
tb_test -c 1 lb_generate_password aaa
tb_test lb_generate_password
tb_test lb_generate_password 8


# send email
tb_test lb_email -s Test junk@example.com "This is a test email."


# avoid skipping tests if last failed
return 0
