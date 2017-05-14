# core operations tests

# is a number
tb_test -c 1 lb_is_number
tb_test -c 1 lb_is_number TEST
tb_test lb_is_number 2
tb_test lb_is_number -99
tb_test lb_is_number 20.16
tb_test lb_is_number -0.9


# is integer
tb_test -c 1 lb_is_integer
tb_test -c 1 lb_is_integer TEST
tb_test lb_is_integer 2
tb_test lb_is_integer -99


# is boolean
tb_test -c 1 lb_is_boolean
tb_test -c 1 lb_is_boolean TEST
tb_test -c 1 lb_is_boolean 1
tb_test lb_is_boolean true
tb_test lb_is_boolean false


# is email
tb_test -c 1 lb_is_email domain.com
tb_test -c 1 lb_is_email blah@blah
tb_test lb_is_email me@domain.com


# trim text
tb_test -c 1 lb_trim
tb_test -r "abc" lb_trim "    abc   "
tb_test -r "a  b    c" lb_trim " a  b    c    "


# array contains
tb_test -c 1 lb_array_contains x
tb_test -c 2 lb_array_contains z a b c
tb_test lb_array_contains 2 1 2 3


# compare versions
tb_test -c 1 lb_compare_versions a b
tb_test -c 1 lb_compare_versions a b c
tb_test -c 1 lb_compare_versions a b c
tb_test -c 1 lb_compare_versions a.b -gt c.d
tb_test -c 1 lb_compare_versions a -eq b
tb_test lb_compare_versions a -eq a
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
