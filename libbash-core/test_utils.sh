# core utils tests

# detect os
tb_test lb_current_os
tb_test lb_detect_os


# detect uid
tb_test lb_current_uid


# test if a user exists
tb_test lb_user_exists $lb_current_user
tb_test -c 1 lb_user_exists
tb_test -c 1 lb_user_exists badUserName
tb_test -c 1 lb_user_exists $lb_current_user badUserName

# test if root
[ $(id -u) = 0 ]
tb_test -c $? lb_ami_root

# test if a user is in a group
tb_test -c 1 lb_in_group
tb_test -c 3 lb_in_group group badUserName
tb_test -c 2 lb_in_group badGroupName
# test with getting the first group of current user
test_groups=($(groups))
tb_test lb_in_group $test_groups $lb_current_user


# test if a group exists
tb_test -c 1 lb_group_exists

case $lb_current_os in
	BSD|Linux)
		tb_test -c 1 lb_group_exists badGroupName
		tb_test lb_group_exists $(groups 2> /dev/null | awk '{ print $1 }')
		;;
	*)
		# other OS not supported
		tb_test -c 2 lb_group_exists anygroup
		;;
esac


# get members of a group
tb_test -c 1 lb_group_members

case $lb_current_os in
	BSD|Linux)
		tb_test -c 2 lb_group_members badGroupName
		# on Ubuntu, this may return nothing, so we did not check results
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
pwd=$(lb_generate_password 8)
tb_test -n "Generate password of 8 characters" [ ${#pwd} = 8 ]


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

	tb_test -n "Email from stdin" -r 0 -v $(echo "This is an email from stdin" | lb_email -s "$tb_email_prefix Email from stdin" $tb_email_dest; echo $?)

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
true
