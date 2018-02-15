#!/bin/bash
# base level EC2 bootstrap script
# Brad Smith - 29/nov/2017
yum update -y
yum install wget
yum install httpd -y  
yum install perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https -y
yum -y install python-pip
yum install -y git vim-enhanced

#apache setup
echo "This is a test web page" > /var/www/html/index.html  
service httpd start
#Cloudwatch tools
mkdir /CloudWatch
cd /CloudWatch
curl http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip -O
unzip CloudWatchMonitoringScripts-1.2.1.zip
rm -rf CloudWatchMonitoringScripts-1.2.1.zip
cd aws-scripts-mon
./mon-put-instance-data.pl --mem-util --verify --verbose > CloudWatchtest.log
./mon-put-instance-data.pl --mem-util --mem-used --mem-avail
# setup cronjob for cloudwatch metrics
echo "*/5 * * * * root /CloudWatch/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-used --mem-avail" >> /etc/crontab
#user set up
git config --global user.name "Brad Smith"
git config --global user.email "brad@bradfsmith.com"
curl https://raw.githubusercontent.com/bradfsmith/Test-repository/edc22cfa190919f13bfe27f3620005a8cd7c589c/brads-bashrc -o ~/.bashrc
# curl https://raw.githubusercontent.com/bradfsmith/Test-repository/master/vimrc.txt -o ~/.vimrc
cp ~/.bashrc /home/ec2-user/.bashrc
chown ec2-user.ec2user /home/ec2-user/.bashrc