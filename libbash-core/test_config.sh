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

# test with empty file
tb_test -n "Create config file" touch "$configfile"
tb_test lb_set_config "$configfile" test false

# reset config
cat > "$configfile" <<EOF
[global]
boolean1=false
boolean2 = false
int1=99
int2 = 99
arr1=("opt 1" "opt 2")
arr2 = ("opt 1" "opt 2")
str1 = hi
str2="hello world"
str3  =  'hello world '

[part0]
int0 = 00

[part1]
int1=11
#default1 =
;default2 =

[part2]
int1=88

EOF


#
#  Analyse config
#

tb_test -i lb_read_config -a "$configfile"
for c in $(seq 0 13) ; do
	case $c in
		0)
			p=global.boolean1
			;;
		1)
			p=global.boolean2
			;;
		2)
			p=global.int1
			;;
		3)
			p=global.int2
			;;
		4)
			p=global.arr1
			;;
		5)
			p=global.arr2
			;;
		6)
			p=global.str1
			;;
		7)
			p=global.str2
			;;
		8)
			p=global.str3
			;;
		9)
			p=part0.int0
			;;
		10)
			p=part1.int1
			;;
		11)
			p=part1.default1
			;;
		12)
			p=part1.default2
			;;
		13)
			p=part2.int1
			;;
	esac
	tb_test -n "Analysed config file $c" -r "$p" -v "${lb_read_config[c]}"
done


#
#  Import config (1)
#

# partial import
tb_test -i lb_import_config -e "$configfile" part0.int0
tb_test -n "Partial import" -r 00 -v $int0

# complete import
tb_test -i lb_import_config -e "$configfile"

# adding bad parameters
echo "this is non sense" >> "$configfile"


#
#  Read config
#

res=0
tb_test -i lb_read_config "$configfile" || res=$?

if [ $res = 0 ] ; then
	tb_test -n "Config file lines > 0" [ ${#lb_read_config[@]} -gt 0 ] && \
	tb_test -n "Last line of config file" -r "this is non sense" -v ${lb_read_config[${#lb_read_config[@]}-1]}
fi

# read section
tb_test -i lb_read_config -s global "$configfile"
tb_test -n "Last line of global section" -r "str3 = 'hello world '" -v ${lb_read_config[${#lb_read_config[@]}-1]}


#
#  Import config (2)
#

# test import with errors
tb_test -c 3 lb_import_config -e "$configfile"

tb_test -n "Imported part2.int1" -r 88 -v $int1

# adding shell injection
cat >> "$configfile" <<EOF
unsecure="\$(echo "injection")"
EOF

# test import in unsecure mode
tb_test -c 4 lb_import_config -e "$configfile"
tb_test -n "code injection avoided" -r "" -v "$unsecure"
tb_test -c 3 -i lb_import_config -e -u "$configfile"
tb_test -n "code injection succeeded" -r injection -v "$unsecure"

# test loading section
tb_test -i lb_import_config -s global "$configfile"

# test values
tb_test -n "imported boolean1" -r false -v $boolean1
tb_test -n "imported boolean2" -r false -v $boolean2
tb_test -n "imported int1" -r 99 -v $int1
tb_test -n "imported int2" -r 99 -v $int2
tb_test -n "imported arr1[0]" -r "opt 1" -v "${arr1[0]}"
tb_test -n "imported arr2[1]" -r "opt 2" -v "${arr2[1]}"
tb_test -n "imported str1" -r hi -v "$str1"
tb_test -n "imported str2" -r "hello world" -v "$str2"
tb_test -n "imported str3" -r "hello world " -v "$str3"


#
#  Get config
#

# get config errors
tb_test -c 1 lb_get_config
tb_test -c 1 lb_get_config badConfigFile
tb_test -c 1 lb_get_config "$configfile" bad/parameter

# get config: testing from a file and from stdin
test_lb_get_config() {
	# test from file
	tb_test -r "$2" lb_get_config "$configfile" "$1"
	# test from stdin
	local test=$(cat "$configfile" | lb_get_config - "$1")
	tb_test -n "lb_get_config $1 from stdin" -r "$2" -v "$test"
}

test_lb_get_config str1 hi
test_lb_get_config str2 "hello world"
test_lb_get_config str3 "hello world "


#
#  Set config
#

# set values
tb_test -c 1 lb_set_config
tb_test -c 1 lb_set_config badConfigFile
tb_test -c 1 lb_set_config "$configfile"
tb_test -c 1 lb_set_config "$configfile" bad/parameter
tb_test -c 3 lb_set_config --strict "$configfile" badParameter value
tb_test lb_set_config "$configfile" int1 01

# test values
tb_test -r 01 lb_get_config "$configfile" int1

# set value in section
tb_test lb_set_config -s global "$configfile" int1 101
tb_test -r 101 lb_get_config -s global "$configfile" int1
tb_test lb_set_config -s global "$configfile" str4 'with spaces'
tb_test -r 'with spaces' lb_get_config -s global "$configfile" str4
tb_test lb_set_config -s part2 "$configfile" int1 102
tb_test -r 102 lb_get_config -s part2 "$configfile" int1


#
#  Migrate config
#

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
true
