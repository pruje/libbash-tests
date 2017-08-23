# libbash gui tests

# avoid this script to be run without being called
if [ -z "$gui" ] ; then
	return 0
fi


# get GUI
tb_test -r "$lbg_gui" lbg_get_gui


# set bad GUI
tb_test -i -c 1 lbg_set_gui badGUItool


# set gui tool
# interactive mode to not loose context
tb_test -i lbg_set_gui $gui
if [ $? != 0 ] ; then
	echo "GUI $gui not supported"
	return 0
fi


# display info
tb_test -c 1 lbg_display_info
tb_test -i lbg_display_info "This is a message for you."


# display warning
tb_test -c 1 lbg_display_warning
tb_test -i lbg_display_warning "This is a warning message for you."


# display error
tb_test -c 1 lbg_display_error
tb_test -i lbg_display_error "This is an error message for you."


# display debug
tb_test -c 1 lbg_display_debug
tb_test -i lbg_display_debug -t DEBUG "This is a debug message for you."


# notifications
tb_test -c 1 lbg_notify
tb_test -i lbg_notify -t TEST "This is a notification test"
tb_test -i lbg_notify --timeout 5 "This notification will disappear in 5 seconds..."


# input text
tb_test -c 1 lbg_input_text
tb_test -i -c 2 lbg_input_text "Please cancel" <<EOF
EOF
tb_test -i lbg_input_text -t TEST -d yes "Your window should be named 'TEST'. Press 'Yes!' (default)." <<EOF
EOF


# input password
tb_test -c 1 lbg_input_password -l
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
tb_test -r x -v $lbg_input_password


# yes/no dialog
tb_test -c 1 lbg_yesno
tb_test -i -c 2 lbg_yesno "Press 'No' (should be in your language)" <<EOF
EOF
tb_test -i lbg_yesno -t "TEST" -y --yes-label "Yes!" --no-label "Nooo" "Your window should be named 'TEST'. Press 'Yes!' (default)." <<EOF
EOF


# choose option
tb_test -c 1 lbg_choose_option
tb_test -i -c 2 lbg_choose_option -l "CANCEL:" bad option <<EOF
EOF
tb_test -i lbg_choose_option -t TEST -d 2 -l "Choose2:" one two three <<EOF
EOF
tb_test -r 2 -v $lbg_choose_option


# choose directory
tb_test -c 1 lbg_choose_directory notAdirectory

if [ "$(lbg_get_gui)" == "console" ] ; then
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
	tb_test -r /cygdrive/c/Users -v $lbg_choose_directory

else
	# other systems
	tb_test -i lbg_choose_directory -a / <<EOF
EOF
	tb_test -r / -v $lbg_choose_directory

	tb_test -i lbg_choose_directory -a . <<EOF
EOF
	tb_test -r "$(lb_abspath .)" -v $lbg_choose_directory
fi


# choose file
tb_test -c 1 lbg_choose_file notAvalidPath
if [ "$(lbg_get_gui)" == "console" ] ; then
	tb_test -i -c 3 lbg_choose_file -t "Please_CANCEL" <<EOF
badFile!
EOF
else
	tb_test -i -c 2 lbg_choose_file -t "Please_CANCEL"
fi

# do not run with test function because of the * symbol
lbg_choose_file -f '*.sh' "$0" <<EOF
EOF
tb_test -r "$(lb_abspath "$0")" -v "$(lb_abspath "$lbg_choose_file")"

# save new file
newfile="$(dirname "$BASH_SOURCE")/newFile"
tb_test -i lbg_choose_file -a -s "$newfile" <<EOF
EOF
tb_test -r "$(lb_abspath "$newfile")" -v "$lbg_choose_file"


# open directory
tb_test -c 1 lbg_open_directory badDirectory
tb_test -c 1 lbg_open_directory -e
tb_test -c 2 lbg_open_directory -e badCommand

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
