# core operations tests

# is a number
tb_test lb_is_number 2
tb_test lb_is_number -99
tb_test lb_is_number 20.16
tb_test lb_is_number -0.9
tb_test -c 1 lb_is_number
tb_test -c 1 lb_is_number TEST
tb_test -c 1 lb_is_number 1 TEST
tb_test -c 1 lb_is_number " 123.45 "


# is integer
tb_test lb_is_integer 0
tb_test lb_is_integer 123
tb_test lb_is_integer -1
tb_test lb_is_integer -99
tb_test -c 1 lb_is_integer
tb_test -c 1 lb_is_integer TEST
tb_test -c 1 lb_is_integer " 123 "


# is boolean
tb_test lb_is_boolean true
tb_test lb_is_boolean false
tb_test -c 1 lb_is_boolean
tb_test -c 1 lb_is_boolean TEST
tb_test -c 1 lb_is_boolean 1
tb_test -c 1 lb_is_boolean truefalse


# is email
tb_test lb_is_email me@domain.com
tb_test lb_is_email me_at-my.domain@my.domain.com
tb_test -c 1 lb_is_email domain.com
tb_test -c 1 lb_is_email blah@blah


# trim text
tb_test lb_trim
tb_test -r "abc" lb_trim "    abc   "
tb_test -r "a  b    c" lb_trim " a  b    c    "


# split string
tb_test -i lb_split ,
tb_test -n "check lb_split empty" -r "" -v ${lb_split[@]}
tb_test -i lb_split , "1,2,3,4"
tb_test -n "check lb_split" -r "1 2 3 4" -v ${lb_split[@]}
tb_test -c 1 lb_split


# join array
tb_test -r "" lb_join ,
array=(1 2 3 4)
tb_test -r "1,2,3,4" lb_join , ${array[@]}
tb_test -c 1 lb_join


# array contains
tb_test lb_array_contains 2 1 2 3
tb_test -c 1 lb_array_contains
tb_test -c 2 lb_array_contains x
tb_test -c 2 lb_array_contains z a b c


# date to timestamp conversion
tb_test -c 1 lb_date2timestamp
tb_test -c 2 lb_date2timestamp badDate
tb_test -r 1514764799 lb_date2timestamp --utc '2017-12-31 23:59:59'


# timestamp to date conversion
tb_test -c 1 lb_timestamp2date
tb_test -c 1 lb_timestamp2date badTimestamp
tb_test -r 20171231235959 lb_timestamp2date -f '%Y%m%d%H%M%S' --utc 1514764799


# compare versions
tb_test -c 1 lb_compare_versions a b
tb_test -c 1 lb_compare_versions a b c
tb_test -c 1 lb_compare_versions a b c
tb_test -c 1 lb_compare_versions a.b -gt c.d
tb_test -c 1 lb_compare_versions a -eq b
tb_test lb_compare_versions a -eq a
tb_test lb_compare_versions 0.1 -eq 0.1.0
tb_test lb_compare_versions 0.0.1 -lt 0.0.2
tb_test lb_compare_versions 1 -eq 1.0.0
tb_test lb_compare_versions 1 -ge 1.0.0
tb_test lb_compare_versions 1 -le 1.0.0
tb_test lb_compare_versions 1 -gt 0.9.9
tb_test lb_compare_versions 1 -lt 2.0.0
tb_test lb_compare_versions 1.0-beta -eq 1.0.0-beta
tb_test lb_compare_versions 1.0-beta -gt 1.0.0-alpha
tb_test lb_compare_versions 1.0-beta -le 1.0.0-beta.0
tb_test lb_compare_versions 1.0-beta -lt 1.0.0-rc
tb_test lb_compare_versions 1.0-beta -le 1.0.0-beta


# is comment
tb_test -c 1 lb_is_comment -s
tb_test -c 3 lb_is_comment -n
tb_test -c 2 lb_is_comment "Hello"
tb_test lb_is_comment "# Comment"
tb_test lb_is_comment -s "//" "//Comment"


# avoid skipping tests if last failed
return 0
