echo -e "\e[31m Install golang  \e[0m"
yum install golang -y  &>>/tmp/roboshop.log

echo -e "\e[31m add application user \e[0m"
useradd roboshop  &>>/tmp/roboshop.log

echo -e "\e[31m create application directory \e[0m"
rm -rf /app  &>>/tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[31m Download Application content \e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip  &>>/tmp/roboshop.log
cd /app

echo -e "\e[31m Extract application content \e[0m"
unzip /tmp/dispatch.zip  &>>/tmp/roboshop.log

echo -e "\e[31m download the dependencies & build the software
\e[0m"
cd /app
go mod init dispatch  &>>/tmp/roboshop.log
go get  &>>/tmp/roboshop.log
go build  &>>/tmp/roboshop.log

echo -e "\e[31m  setup systemd service \e[0m"
cp /root/Roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service   &>>/tmp/roboshop.log

echo -e "\e[31m start dispatch service  \e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable dispatch  &>>/tmp/roboshop.log
systemctl restart dispatch  &>>/tmp/roboshop.log

