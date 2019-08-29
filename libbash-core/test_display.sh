# core display and logs tests

# print text
tb_test -i lb_print -n No carriage return here:
tb_test -i lb_print Next line
tb_test -i lb_echo Next line
tb_test -i lb_print --bold This is bold
tb_test -i lb_print --cyan This is cyan
tb_test -i lb_print --green This is green
tb_test -i lb_print --yellow This is yellow
tb_test -i lb_print --red This is red

# test print with stdin mode
tb_test -r "abc" -v "$(echo abc | lb_print)"

# disable formatting to test result
lb__format_print=false

# display text
tb_test -r Hello lb_display Hello
tb_test -r "[INFO]  Hello" lb_display -p -l INFO Hello

# reset formatting
[ "$lb_current_os" != macOS ] && lb__format_print=true

# define test log file
tb_logfile=./testbash_testlog.log


# set log file
[ "$lb_current_os" != Windows ] && tb_test -c 2 lb_set_logfile /test.log
tb_test -i lb_set_logfile "$tb_logfile"


# get log file
tb_test -r "$tb_logfile" lb_get_logfile


# display messages
tb_test -i lb_display_info --log "Hello world"
tb_test -i lb_display_warning "Don't panic!"
tb_test -i lb_display_error "It's just an error."
tb_test -i lb_display_critical "It's worse..."
tb_test -i lb_display_debug "I don't care"

# display levels
tb_test -i -c 2 lb_set_display_level BADLEVEL
tb_test -i lb_set_display_level INFO
tb_test lb_get_display_level
tb_test -r "" lb_display --level DEBUG notDisplayed

# log levels
tb_test -r DEBUG lb_get_loglevel
tb_test -i -c 2 lb_set_loglevel BADLEVEL
tb_test -i lb_set_loglevel INFO


# print in log
tb_test lb_log -n "logline1"
tb_test -r "logline1" tail -1 "$tb_logfile"
tb_test -i lb_set_loglevel INFO
tb_test lb_log Hello this is a log file
tb_test lb_log -a -l ERROR This is an error
tb_test lb_log_info --log "Hello world"
tb_test lb_log_warning "Don't panic!"
tb_test lb_log_error "It's just an error."
tb_test lb_log_critical "It's worse..."
tb_test lb_log -l INFO info
tb_test -r info tail -n 1 "$tb_logfile"
tb_test -i lb_display_debug You should not see that.
tb_test lb_log -p -l DEBUG You should not see that.
tb_test -r "info" tail -1 "$tb_logfile"
tb_test lb_log
tb_test -r "" tail -n 1 "$tb_logfile"


# print result
tb_test -c 1 lb_result -l

res=0
dumbcommand &> /dev/null || res=$?
tb_test -i -c 127 lb_result $res

true
tb_test -i lb_result --log $?

res=0
dumbcommand &> /dev/null || res=$?
tb_test -i -c 127 lb_short_result $res

true
tb_test -i lb_short_result --log $?

# delete test log file
rm -f "$tb_logfile"


# avoid skipping tests if last failed
return 0
