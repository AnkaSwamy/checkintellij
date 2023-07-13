source common.sh
echo -e "${color} Copy mongodb repo file ${nocolor}"
cp /root/Roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo  &>>$log_file
stat_check $?

echo -e "${color} Installing mongodb server ${nocolor}"
yum install mongodb-org -y  &>>$log_file
stat_check $?

echo -e "${color} Update mongodb listen address ${nocolor}"
sed -i  's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat_check $?
echo -e "${color} Start mongodb server ${nocolor}"
systemctl enable mongod  &>>$log_file
systemctl restart mongod  &>>$log_file
stat_check $?
