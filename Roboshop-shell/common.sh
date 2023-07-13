color="\e[35m"
nocolor="\e[0m"
app_path="/app"
log_file="/tmp/roboshop.log"
user_id=$(id -u)
if [ $user_id -ne 0 ]; then
  echo Script should be running with SUDO
  exit 1
  fi
stat_check() {
  if [ $1 -eq 0 ]; then
        echo SUCCESS
        else
        echo FAILURE
        exit 1
        fi
  }
  app_presetup() {
    echo -e "${color} Add an application user ${nocolor}"
    id roboshop  &>>$log_file
    if [ $? -eq 1 ]; then
    useradd roboshop  &>>$log_file
    fi
    stat_check $?

    echo -e "${color} Create an application directory ${nocolor}"
    rm -rf ${app_path}
    mkdir ${app_path}  &>>$log_file
    stat_check $?

    echo -e "${color} Download application content ${nocolor}"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip   &>>$log_file
    stat_check $?

    echo -e "${color} Extract application content ${nocolor}"
    cd ${app_path}
    unzip /tmp/$component.zip  &>>$log_file
    stat_check $?
    }

  systemd_setup() {
    echo -e "${color} Setup systemd service ${nocolor}"
    cp /root/Roboshop-shell/$component.service /etc/systemd/system/$component.service  &>>$log_file
    sed -i -e "s/roboshop_app_password/$roboshop_app_password/"  /root/Roboshop-shell/$component.service
    stat_check $?
    echo -e "${color}  Start the $component service ${nocolor}"
    systemctl daemon-reload   &>>$log_file
    systemctl enable $component  &>>$log_file
    systemctl restart $component &>>$log_file
    stat_check $?
  }
  nodejs() {
    echo -e "${color} Configure nodejs repos ${nocolor}"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash   &>>$log_file
    stat_check $?
    echo -e "${color} Install nodejs ${nocolor}"
    yum install nodejs -y  &>>$log_file
    stat_check $?
    app_presetup

    echo -e "${color} Install nodejs dependencies ${nocolor}"
    npm install  &>>$log_file
    stat_check $?
    systemd_setup
    }

  mongo_schema_setup() {
    echo -e "${color}  copy mongodb repo file ${nocolor}"
    cp /root/Roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo  &>>$log_file
    stat_check $?
    echo -e "${color}  Install Mongodb client ${nocolor}"
    yum install mongodb-org-shell -y  &>>$log_file
    stat_check $?
    echo -e "${color} Load schema ${nocolor}"
    mongo --host mongodb-dev.ankadevopsb73.store <${app_path}/schema/$component.js  &>>$log_file
    stat_check $?
    }

  mysql_schema_setup() {
    echo -e "${color} Install mysql client ${nocolor}"
    yum install mysql -y  &>>log_file
    stat_check $?
    echo -e "${color} load schema ${nocolor}"
    mysql -h  mysql-dev.ankadevopsb73.store -uroot -pRoboShop@1 <${app_path}/schema/$component.sql   &>>log_file
    stat_check $?
    }
  maven() {
    echo -e "${color}  Install Maven ${nocolor}"
    yum install maven -y  &>>$log_file
    stat_check $?
    app_presetup

    echo -e "${color}  Download maven dependencies ${nocolor}"
    mvn clean package
    mv target/$component-1.0.jar $component.jar
    stat_check $?

    mysql_schema_setup

    systemd_setup
   }

  python() {
    echo -e "${color} Install python ${nocolor}"
    yum install python36 gcc python3-devel -y  &>>log_file
    stat_check $?

    app_presetup

    echo -e "${color} Install application dependencies ${nocolor}"
    cd ${app_path}

    pip3.6 install -r requirements.txt  &>>log_file
    stat_check $?
    systemd_setup
  }
