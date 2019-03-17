# core utils tests

# detect os
tb_test lb_current_os
tb_test lb_detect_os


# test if a user exists
tb_test lb_user_exists $lb_current_user
tb_test -c 1 lb_user_exists
tb_test -c 1 lb_user_exists badUserName
tb_test -c 1 lb_user_exists $lb_current_user badUserName


# test if a user is in a group
tb_test -c 1 lb_in_group
tb_test -c 3 lb_in_group group badUserName
tb_test -c 2 lb_in_group badGroupName
# test with getting the first group of current user
test_groups=($(groups))
tb_test lb_in_group $test_groups $lb_current_user


# get list of members of a group
tb_test -c 1 lb_group_members

case $lb_current_os in
	Linux)
		tb_test -c 2 lb_group_members badGroupName
		# on Ubuntu, this can return nothing, so we did not compare results
		tb_test lb_group_members $lb_current_user
		;;
	*)
		# other OS not supported
		tb_test -c 3 lb_group_members $lb_current_user
		;;
esac


# generate password
tb_test -c 1 lb_generate_password aaa
tb_test lb_generate_password
tb_test lb_generate_password 8


# send email
# SET a destination below to enable tests
tb_email_dest=""

if [ -n "$tb_email_dest" ] ; then
	tb_email_prefix="[libbash.sh unit tests]"
	tb_email_attachment="$(dirname "$(lb_realpath "$BASH_SOURCE")")/mail attachment.txt"

	tb_test -c 1 lb_email
	tb_test -c 1 lb_email missingTheText

	tb_test -n "Simple text email" lb_email -s "$tb_email_prefix Simple text email" $tb_email_dest "This is a simple text email."

	# wait to avoid bugs
	sleep 2

	tb_test -n "HTML/txt email" lb_email -s "$tb_email_prefix Multipart HTML/TXT email" --html \
		"This is a multipart email sent by <a href='https://github.com/pruje/libbash.sh'>libbash.sh</a>, and you are reading the HTML part." \
		$tb_email_dest "This is a multipart email, and you are reading the text part."

	# wait to avoid bugs
	sleep 2

	tb_test -n "Simple text email with attachment" lb_email -s "$tb_email_prefix Simple text email with attachment" -a "$tb_email_attachment" \
		$tb_email_dest "This is a simple text email and you should have an attachment."

	# wait to avoid bugs
	sleep 2

	tb_test -n "HTML/txt email with attachment" lb_email -s "$tb_email_prefix Multipart HTML/TXT email with attachment" -a "$tb_email_attachment" --html \
		"This is a multipart email sent by <a href='https://github.com/pruje/libbash.sh'>libbash.sh</a>, and you are reading the HTML part.<br/>You should have an attachment." \
		$tb_email_dest "This is a multipart email, and you are reading the text part, and you should have an attachment."
fi


# avoid skipping tests if last failed
return 0
