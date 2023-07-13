source common.sh
echo -e "${color} Configure erlang repos ${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>$log_file
stat_check $?

echo -e "${color} Configure Rabbitmq repos ${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>>$log_file
stat_check $?

echo -e "${color} Install Rabbitmq server ${nocolor}"
yum install rabbitmq-server -y  &>>$log_file
stat_check $?

echo -e "${color} Start Rabbitmq service ${nocolor}"
systemctl enable rabbitmq-server  &>>$log_file
systemctl start rabbitmq-server   &>>$log_file
stat_check $?

echo -e "${color} Add Rabbitmq application user ${nocolor}"
rabbitmqctl add_user roboshop $1   &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"   &>>$log_file
stat_check $?