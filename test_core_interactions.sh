# interaction tests

# use input
tb_test -c 1 lb_input_text
tb_test -i lb_input_text -n "Please enter 'xxx':" << EOF
xxx
EOF
tb_test -n "Input text = xxx" -r "xxx" echo "$lb_input_text"

tb_test -i lb_input_text -d "zzz" "Please enter nothing." << EOF
EOF
tb_test -n "Empty input text" -r "zzz" echo "$lb_input_text"


# input password
tb_test -c 1 lb_input_password -l
tb_test -i -c 2 lb_input_password << EOF
EOF

tb_test -i -c 3 lb_input_password -c << EOF
xxx
yyy
EOF

tb_test -i lb_input_password -l "Please enter password 'xxx':" << EOF
xxx
EOF
tb_test -n "Input password = xxx" -r "xxx" echo "$lb_input_password"

tb_test -i lb_input_password -c -l "Please enter password 'xxx':" --confirm-label "Confirm xxx:" << EOF
xxx
xxx
EOF
tb_test -n "Confirmed password = xxx" -r "xxx" echo "$lb_input_password"


# yes or no
tb_test -c 1 lb_yesno
tb_test -i lb_yesno "Do you want to continue?" << EOF
y
EOF

tb_test -i lb_yesno -y --yes-label "yes" "Happy?" << EOF
yes
EOF

tb_test -i -c 2 lb_yesno "Say no?" << EOF
EOF

tb_test -i -c 3 lb_yesno -c "Cancel?" << EOF
c
EOF


# choose option
tb_test -c 1 lb_choose_option -l BadChoice
tb_test -i lb_choose_option -l "ChooseOption2:" one two three << EOF
2
EOF
tb_test -n "Choosed option = 2" -r 2 echo $lb_choose_option

tb_test -i lb_choose_option -d 1 -l "TypeEnter:" ok << EOF
EOF
tb_test -n "Choosed option = 1" -r 1 echo $lb_choose_option

tb_test -i -c 2 lb_choose_option cancel << EOF
EOF

tb_test -i -c 2 lb_choose_option -l "Type.cancel:" -c cancel a b c << EOF
cancel
EOF

tb_test -i -c 3 lb_choose_option choose a bad option << EOF
9999
EOF
