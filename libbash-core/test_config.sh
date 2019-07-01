# core config tests

# read/import config files
tb_test -c 1 lb_read_config
tb_test -c 1 lb_read_config badConfigFile
tb_test -c 1 lb_import_config
tb_test -c 1 lb_import_config badConfigFile

# initialize config values
boolean1=true
boolean2=true

# create a config file
configfile=./testbash_testconfig.conf
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

[part1]
int1=11

[part2]
int1=88
EOF

# import config
tb_test -i -c 2 lb_import_config -e "$configfile" onlyThisParam
tb_test -i lb_import_config -e "$configfile"

# adding bad parameters
cat >> "$configfile" <<EOF
this is non sense
EOF

# read config
res=0
tb_test -i lb_read_config "$configfile" || res=$?

if [ $res == 0 ] ; then
	tb_test -n "Config file lines > 0" [ ${#lb_read_config[@]} -gt 0 ] && \
	tb_test -n "Last line of config file" -r "this is non sense" -v ${lb_read_config[${#lb_read_config[@]}-1]}
fi

# read section
tb_test -i lb_read_config -s global "$configfile"
tb_test -n "Last line of global section" -r "str2 = \"hello world\"" -v ${lb_read_config[${#lb_read_config[@]}-1]}

# test import with errors
tb_test -c 3 lb_import_config -e "$configfile"

tb_test -n "Imported part2.int1" -r 88 -v $int1

# adding shell injection
cat >> "$configfile" <<EOF
unsecure="\$(echo "injection")"
EOF

# test import in unsecure mode
tb_test -c 4 lb_import_config -e "$configfile"
tb_test -c 3 -i lb_import_config -e -u "$configfile"
tb_test -r "injection" -v "$unsecure"

# test loading section
tb_test -i lb_import_config -s global "$configfile"

# test values
tb_test -r false -v $boolean1
tb_test -r $boolean1 -v $boolean2
tb_test -r 99 -v $int1
tb_test -r $int1 -v $int2
tb_test -r "opt 1" -v "${arr1[0]}"
tb_test -r "${arr1[1]}" -v "${arr2[1]}"
tb_test -r "hello world" -v "$str1"
tb_test -r "$str1" -v "$str2"

# set values
tb_test -c 1 lb_set_config
tb_test -c 1 lb_set_config badConfigFile
tb_test -c 1 lb_set_config "$configfile"
tb_test -c 3 lb_set_config --strict "$configfile" badParameter value
tb_test lb_set_config "$configfile" int1 101

# test set values
tb_test -r 99 lb_get_config "$configfile" int1

# set value in section
tb_test lb_set_config -s global "$configfile" int1 101
tb_test -r 101 lb_get_config -s global "$configfile" int1
tb_test lb_set_config -s part2 "$configfile" int1 102
tb_test -r 102 lb_get_config -s part2 "$configfile" int1

# test migrate config
cat > "$configfile".new <<EOF
[part1]
int1 =
EOF

tb_test -c 1 lb_migrate_config
tb_test -c 1 lb_migrate_config badFile
tb_test lb_migrate_config "$configfile" "$configfile".new
tb_test -r 11 lb_get_config -s part1 "$configfile".new int1

# delete test config file
rm -f "$configfile"*

# avoid skipping tests if last failed
return 0
