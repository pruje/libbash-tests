# core utils tests

# detect os
tb_test lb_current_os
tb_test lb_detect_os


# test if a user exists
tb_test -c 1 lb_user_exists
tb_test -c 2 lb_user_exists badUserName
tb_test lb_user_exists $(whoami)


# test if a user is in a group
tb_test -c 1 lb_in_group
tb_test -c 3 lb_in_group group badUserName
tb_test -c 2 lb_in_group badGroupName
# test with getting the first group of current user
test_groups=($(groups))
tb_test lb_in_group $test_groups $(whoami)


# generate password
tb_test -c 1 lb_generate_password aaa
tb_test lb_generate_password
tb_test lb_generate_password 8


# send email
# UNCOMMENT THIS LINE TO TEST IT
#tb_test lb_email -s Test junk@example.com "This is a test email."


# import config files
tb_test -c 1 lb_import_config
tb_test -c 1 lb_import_config badConfigFile

# initialize config values
boolean1=true
boolean2=true

# create a config file
configfile="./testbash_testconfig.conf"
cat > "$configfile" <<EOF
# this is a comment

boolean1=false
   boolean2 = false
int1=99
   int2 = 99
arr1=("opt 1" "opt 2")
   arr2 = ("opt 1" "opt 2")
str1="hello world"
   str2  =  "hello world"
EOF

# import config
tb_test -i lb_import_config -e "$configfile"

# adding bad parameters
cat >> "$configfile" <<EOF
this is non sense
EOF

# test import with errors
tb_test -c 3 lb_import_config -e "$configfile"

# adding shell injection
cat >> "$configfile" <<EOF
unsecure="\$(echo "injection")"
EOF

# test import in unsecure mode
tb_test -c 4 lb_import_config -e "$configfile"
tb_test -c 3 -i lb_import_config -e -u "$configfile"

# test values
tb_test -v -r false $boolean1
tb_test -v -r $boolean1 $boolean2
tb_test -v -r 99 $int1
tb_test -v -r $int1 $int2
tb_test -v -r "opt 1" "${arr1[0]}"
tb_test -v -r "${arr1[1]}" "${arr2[1]}"
tb_test -v -r "hello world" "$str1"
tb_test -v -r "$str1" "$str2"
tb_test -v -r "injection" "$unsecure"

# delete test config file
rm -f "$configfile"

# avoid skipping tests if last failed
return 0
