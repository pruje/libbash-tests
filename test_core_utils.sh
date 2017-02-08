# core utils tests

# detect os
tb_test lb_detect_os


# send email
tb_test lb_email -s Test junk@example.com "This is a test email."


# avoid skipping tests if last failed
return 0
