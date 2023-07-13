source common.sh
echo -e "${color} Disable mysql default version ${nocolor}"
yum module disable mysql -y  &>>$log_file
stat_check $?

echo -e "${color} Copy mysql repo file ${nocolor}"
cp /root/Roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo  &>>$log_file
stat_check $?

echo -e "${color} Install mysql community server ${nocolor}"
yum install mysql-community-server -y  &>>$log_file
stat_check $?

echo -e "${color} start my sql service ${nocolor}"
systemctl enable mysqld  &>>$log_file
systemctl restart mysqld  &>>$log_file
stat_check $?

echo -e "${color}  set up mysql password${nocolor}"
mysql_secure_installation --set-root-pass $1  &>>$log_file
stat_check $?