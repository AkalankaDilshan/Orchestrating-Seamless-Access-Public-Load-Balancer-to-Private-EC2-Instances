#!/bin/bash
#!/bin/bash
# Author: M.K.Akalanka Dilshan
# Date: 2024-12-27
# Time: 21.25


sudo yum update -y


sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Fetch the Availability Zone of the EC2 instance
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)


if [ "$AZ" == "eu-north-1b" ]; then
    BG_COLOR="yellow"
elif [ "$AZ" == "eu-north-1a" ]; then
    BG_COLOR="green"
else
    BG_COLOR="lightgreen" 
fi

echo "<!DOCTYPE html>
<html>
<head>
    <title>Availability Zone</title>
</head>
<body style='background-color:$BG_COLOR; color:black; text-align:center;'>
    <h1>I'm in the $AZ Availability Zone</h1>
</body>
</html>" | sudo tee /var/www/html/index.html

sudo systemctl restart httpd
