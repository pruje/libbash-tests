# core utils tests

# detect os
tb_test lb_current_os
tb_test lb_detect_os


# generate password
tb_test -c 1 lb_generate_password aaa
tb_test lb_generate_password
tb_test lb_generate_password 8


# send email
tb_test lb_email -s Test junk@example.com "This is a test email."


# avoid skipping tests if last failed
return 0
