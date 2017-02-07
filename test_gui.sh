# libbash gui tests

# get GUI
tb_test -r "$lbg_gui" lbg_get_gui


# set bad GUI
tb_test -i -c 2 lbg_set_gui badGUItool


guis=()
# (un)comment to test gui tools

if [ "$(lb_detect_os)" != "macOS" ] ; then
	echo
	guis+=(kdialog)
	guis+=(zenity)
	guis+=(dialog)
else
	echo
	guis+=(osascript)
fi

guis+=(console)


# test every dialog system
for g in ${guis[@]} ; do
	echo
	echo "Test GUI $g:"

	# interactive mode to not loose context

	tb_test -i lbg_set_gui $g
	if [ $? != 0 ] ; then
		echo "GUI $g not supported"
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
	tb_test -i -c 2 lbg_input_text "Please cancel" << EOF
EOF
	tb_test -i lbg_input_text -t TEST -d yes "Your window should be named 'TEST'. Press 'Yes!' (default)." << EOF
EOF


	# input password
	tb_test -c 1 lbg_input_password -l
	tb_test -i -c 2 lbg_input_password -t CANCEL -c -l "CANCEL:" << EOF
EOF
	tb_test -i lbg_input_password -t "Type.x" -c -l "Type.x:" --confirm-label "Retype.x:" << EOF
x
x
EOF
	tb_test -n "lbg password = x" -r x echo $lbg_input_password


	# yes/no dialog
	tb_test -c 1 lbg_yesno
	tb_test -i -c 2 lbg_yesno "Press 'No' (should be in your language)" << EOF
EOF
	tb_test -i lbg_yesno -t "TEST" -y --yes-label "Yes!" --no-label "Nooo" "Your window should be named 'TEST'. Press 'Yes!' (default)." << EOF
EOF


	# choose option
	tb_test -c 1 lbg_choose_option
	tb_test -i -c 2 lbg_choose_option -l "CANCEL:" bad option << EOF
EOF
	tb_test -i lbg_choose_option -t TEST -d 2 -l "Choose2:" one two three << EOF
EOF
	tb_test -n "lbg_choose_option = 2" -r 2 echo $lbg_choose_option


	# choose directory
	tb_test -c 1 lbg_choose_directory notAdirectory

	if [ "$(lbg_get_gui)" == "console" ] ; then
		tb_test -i -c 3 lbg_choose_directory -t "Please_CANCEL" << EOF
badDirectory!
EOF
	else
		tb_test -i -c 2 lbg_choose_directory -t "Please_CANCEL"
	fi

	tb_test -i lbg_choose_directory / << EOF
EOF
	tb_test -n "lbg_choose_directory = /" -r / echo $lbg_choose_directory


	# choose file
	tb_test -c 1 lbg_choose_file notAvalidPath
	if [ "$(lbg_get_gui)" == "console" ] ; then
		tb_test -i -c 3 lbg_choose_file -t "Please_CANCEL" << EOF
badFile!
EOF
	else
		tb_test -i -c 2 lbg_choose_file -t "Please_CANCEL"
	fi

	# do not run with test function because of the * symbol
	lbg_choose_file -f '*.sh' "$0" << EOF
EOF
	tb_test -n "lbg_choose_file = $(lb_realpath $0)" -r "$(lb_realpath $0)" echo "$(lb_realpath $lbg_choose_file)"
done


# avoid skipping tests if last failed
return
