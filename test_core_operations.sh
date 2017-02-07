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


# array contains
tb_test lb_array_contains 2 1 2 3
tb_test -c 1 lb_array_contains x
tb_test -c 2 lb_array_contains z a b c


# avoid skipping tests if last failed
return
