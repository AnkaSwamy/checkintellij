source common.sh

echo -e "${color} Installing Redis repos ${nocolor}"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  &>>$log_file
stat_check $?

echo -e "${color} Enable Redis 6th version ${nocolor}"
yum module enable redis:remi-6.2 -y  &>>$log_file
stat_check $?

echo -e "${color}Install Redis server ${nocolor}"
yum install redis -y  &>>$log_file
stat_check $?

echo -e "${color}update redis listen address ${nocolor}"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf  &>>$log_file
stat_check $?

echo -e "${color} Start the Redis server ${nocolor}"
systemctl enable redis  &>>$log_file
systemctl restart redis  &>>$log_file
stat_check $?

