# core utils tests

# detect os
tb_test lb_current_os
tb_test lb_detect_os


# test if a user exists
tb_test -c 1 lb_user_exists
tb_test -c 2 lb_user_exists badUserName
tb_test lb_user_exists $lb_current_user


# test if a user is in a group
tb_test -c 1 lb_in_group
tb_test -c 3 lb_in_group group badUserName
tb_test -c 2 lb_in_group badGroupName
# test with getting the first group of current user
test_groups=($(groups))
tb_test lb_in_group $test_groups $lb_current_user


# get list of members of a group
tb_test -c 1 lb_group_members

if [ "$lb_current_os" == Linux ] ; then
	tb_test -c 2 lb_group_members badGroupName
	# on Ubuntu, this can return nothing, so we did not compare results
	tb_test lb_group_members $lb_current_user
else
	tb_test -c 3 lb_group_members $lb_current_user
fi


# generate password
tb_test -c 1 lb_generate_password aaa
tb_test lb_generate_password
tb_test lb_generate_password 8


# send email
# UNCOMMENT THIS LINE TO TEST IT
#tb_test lb_email -s Test junk@example.com "This is a test email."


# read/import config files
tb_test -c 1 lb_read_config
tb_test -c 1 lb_read_config badConfigFile
tb_test -c 1 lb_import_config
tb_test -c 1 lb_import_config badConfigFile

# initialize config values
boolean1=true
boolean2=true

# create a config file
configfile="./testbash_testconfig.conf"
cat > "$configfile" <<EOF
# this is a comment
; this is another comment

[global]
boolean1=false
   boolean2 = false
int1=99
   int2 = 99
arr1=("opt 1" "opt 2")
   arr2 = ("opt 1" "opt 2")
str1="hello world"
   str2  =  "hello world"

[part2]
int1=88
EOF

# import config
tb_test -i lb_import_config -e "$configfile"
echo $?
# adding bad parameters
cat >> "$configfile" <<EOF
this is non sense
EOF

# read config
tb_test -i lb_read_config "$configfile"
tb_test -n "Config file lines > 0" [ ${#lb_read_config[@]} -gt 0 ]
if [ $? == 0 ] ; then
	tb_test -n "Last line of config file" -v -r "this is non sense" ${lb_read_config[${#lb_read_config[@]}-1]}
fi

# read section
tb_test -i lb_read_config -s global "$configfile"
tb_test -n "Last line of global section" -v -r "str2 = \"hello world\"" ${lb_read_config[${#lb_read_config[@]}-1]}

# test import with errors
tb_test -c 3 lb_import_config -e "$configfile"

tb_test -v -r 88 $int1

# adding shell injection
cat >> "$configfile" <<EOF
unsecure="\$(echo "injection")"
EOF

# test import in unsecure mode
tb_test -c 4 lb_import_config -e "$configfile"
tb_test -c 3 -i lb_import_config -e -u "$configfile"
tb_test -v -r "injection" "$unsecure"

# test loading section
tb_test -i lb_import_config -s global "$configfile"

# test values
tb_test -v -r false $boolean1
tb_test -v -r $boolean1 $boolean2
tb_test -v -r 99 $int1
tb_test -v -r $int1 $int2
tb_test -v -r "opt 1" "${arr1[0]}"
tb_test -v -r "${arr1[1]}" "${arr2[1]}"
tb_test -v -r "hello world" "$str1"
tb_test -v -r "$str1" "$str2"

# set values
tb_test -c 1 lb_set_config
tb_test -c 1 lb_set_config badConfigFile
tb_test -c 1 lb_set_config "$configfile"
tb_test -c 3 lb_set_config --strict "$configfile" badParameter value
tb_test lb_set_config "$configfile" int1 101

# test set values
tb_test -i lb_import_config "$configfile"
tb_test -v -r 101 $int1

# set value in section
tb_test lb_set_config -s global "$configfile" int1 101
tb_test -i lb_import_config -s global "$configfile"
tb_test -v -r 101 $int1
tb_test lb_set_config -s part2 "$configfile" int1 102
tb_test -i lb_import_config -s part2 "$configfile"
tb_test -v -r 102 $int1

# delete test config file
rm -f "$configfile"*

# avoid skipping tests if last failed
return 0
