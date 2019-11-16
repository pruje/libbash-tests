# libbash gui tests

# avoid this script to be run without being called
[ -z "$gui" ] && return 0


# set gui tool
# interactive mode to not loose context
tb_test -i lbg_set_gui $gui || return 0


# display info
tb_test -i lbg_display_info "This is a message for you."
echo "This is a text from stdin" | lbg_info
tb_test -n "display from stdin" -r 0 -v $?

# display warning
tb_test -i lbg_display_warning "This is a warning message for you."


# display error
tb_test -i lbg_display_error "This is an error message for you."


# display debug
tb_test -i lbg_display_debug -t DEBUG "This is a debug message for you."


# notifications
tb_test -i lbg_notify -t TEST "This is a notification test"
tb_test -i lbg_notify --timeout 5 "This notification will disappear in 5 seconds..."
echo "Test from stdin" | lbg_notify
tb_test -n "notify from stdin" -r 0 -v $?

# input text
tb_test -i -c 2 lbg_input_text "Please cancel" <<EOF
EOF
tb_test -i lbg_input_text -t TEST -d yes "Your window should be named 'TEST'. Press 'Yes!' (default)." <<EOF
EOF


# input password
tb_test -i -c 2 lbg_input_password -t CANCEL "CANCEL:" <<EOF
EOF
tb_test -i -c 4 lbg_input_password -t "Enter 1 character" -m 2 "Enter 1 character:" <<EOF
x
EOF
tb_test -i -c 3 lbg_input_password -t "Enter something" -c --confirm-label "Enter something different:" -m 1 "Enter something:" <<EOF
x
y
EOF
tb_test -i lbg_input_password -t "Enter x twice" -c --confirm-label "Re-enter x:" -m 1 "Enter x:" <<EOF
x
x
EOF
tb_test -n "Chosen password" -r x -v $lbg_input_password


# yes/no dialog
tb_test -i -c 2 lbg_yesno "Press 'No' (should be in your language)" <<EOF
EOF
tb_test -i lbg_yesno -t "TEST" -y --yes-label "Yes!" --no-label "Nooo" "Your window should be named 'TEST'. Press 'Yes!' (default)." <<EOF
EOF


# choose option
tb_test -i -c 2 lbg_choose_option -l "Please CANCEL:" bad option <<EOF
EOF
tb_test -i lbg_choose_option -t TEST -d 2 -l "Please choose 2:" one two three <<EOF
EOF
tb_test -n "Chosen option" -r 2 -v $lbg_choose_option

# choose multiple options
res=0
# macOS not compatible yet
[ "$(lbg_get_gui)" == osascript ] && res=1
tb_test -i -c $res lbg_choose_option -t TEST -m -d 1,3 -l "Please choose 1 and 3:" one two three <<EOF
EOF
[ $res == 0 ] && tb_test -n "Chosen option" -r "1 3" -v "${lbg_choose_option[*]}"


# choose directory
if [ "$(lbg_get_gui)" == console ] ; then
	tb_test -i -c 3 lbg_choose_directory -t "Please_CANCEL" <<EOF
badDirectory!
EOF
else
	tb_test -i -c 2 lbg_choose_directory -t "Please_CANCEL"
fi

if [ "$lb_current_os" == Windows ] ; then
	# Windows systems
	tb_test -i lbg_choose_directory -t "Please CHOOSE C:\\Users" -a /cygdrive/c/Users <<EOF
EOF
	tb_test -n "Chosen directory" -r /cygdrive/c/Users -v $lbg_choose_directory

else
	# other systems
	tb_test -i lbg_choose_directory -t "Please choose /" -a / <<EOF
EOF
	tb_test -n "Chosen directory" -r / -v $lbg_choose_directory

	tb_test -i lbg_choose_directory -a . <<EOF
EOF
	tb_test -n "Chosen directory" -r "$(lb_abspath .)" -v $lbg_choose_directory
fi


# choose file
if [ "$(lbg_get_gui)" == console ] ; then
	tb_test -i -c 3 lbg_choose_file -t "Please_CANCEL" <<EOF
badFile!
EOF
else
	tb_test -i -c 2 lbg_choose_file -t "Please_CANCEL"
fi

# do not run with test function because of the * symbol
lbg_choose_file -t "Choose a SHELL file" -f '*.sh' "$0" <<EOF
EOF
tb_test -n "Chosen file" -r "$(lb_abspath "$0")" -v "$(lb_abspath "$lbg_choose_file")"

# save new file
newfile=$(dirname "$BASH_SOURCE")/newFile
tb_test -i lbg_choose_file -a -s "$newfile" <<EOF
EOF
tb_test -n "Chosen new file" -r "$(lb_abspath "$newfile")" -v "$lbg_choose_file"


# open directory
# testing custom explorers
if lb_command_exists dolphin ; then
	tb_test lbg_open_directory -e dolphin
fi

tb_test -c 4 lbg_open_directory badDirectory .

if [ "$lb_current_os" == Windows ] ; then
	tb_test lbg_open_directory "c:\\"
else
	tb_test lbg_open_directory /
fi

# avoid skipping tests if last failed
return 0
