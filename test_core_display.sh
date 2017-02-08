# core display and logs tests

# print text
lb_print -n No carriage return here:
lb_print Next line
lb_print --bold This is bold
lb_print --cyan This is cyan
lb_print --green This is green
lb_print --yellow This is yellow
lb_print --red This is red

# disable formatting to test result
lb_format_print=false

# display text
tb_test -r Hello lb_display Hello
tb_test -r "[INFO]  Hello" lb_display -p -l INFO "Hello"

# reset formatting
if [ "$(lb_detect_os)" != "macOS" ] ; then
	lb_format_print=true
fi

# define test log file
t_logfile="./testbash_testlog.log"


# set log file
tb_test -c 2 lb_set_logfile /test.log
tb_test -i lb_set_logfile "$t_logfile"


# get log file
tb_test -r "$t_logfile" lb_get_logfile


# display messages
tb_test -i lb_display_info --log Hello world!
tb_test -i lb_display_warning "Don't panic!"
tb_test -i lb_display_error "It's just an error."
tb_test -i lb_display_debug "I don't care"


# log levels
tb_test -r DEBUG lb_get_loglevel
tb_test -i -c 2 lb_set_loglevel BADLEVEL
tb_test -i lb_set_loglevel INFO


# print in log
tb_test lb_log -n "its just..."
tb_test -i lb_set_loglevel INFO
tb_test lb_log Hello this is a log file
tb_test lb_log -a -l ERROR This is an error
tb_test lb_log -l INFO info
tb_test -r info tail -n 1 "$t_logfile"
tb_test -i lb_display_debug You should not see that.
tb_test lb_log -p -l DEBUG You should not see that.
tb_test lb_log
tb_test -r "" tail -n 1 "$t_logfile"


# print result
tb_test -c 1 lb_result -l

dumbcommand &> /dev/null
tb_test -i -c 127 lb_result $?

echo &> /dev/null
tb_test -i lb_result --log $?

dumbcommand &> /dev/null
tb_test -i -c 127 lb_short_result $?

echo &> /dev/null
tb_test -i lb_short_result --log $?

# delete test log file
rm -f "$t_logfile"


# avoid skipping tests if last failed
return 0
