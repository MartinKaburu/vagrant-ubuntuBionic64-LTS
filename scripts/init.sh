#! /bin/bash -

# Declare tput red color and reset.
declare -r red=`tput setaf 1`;
declare -r reset=`tput sgr0`;

# Update packages and their dependancies.
updatePackages() {
	echo "${red}---Updating packages---${reset}";
	sudo apt-get update && sudo apt-get install nginx git python3 python3-pip virtualenv -y;
}

# Clone the repo and setup files.
cloneRepo() {
	echo "${red}---Cloning files---${reset}";
	dir="stackoverflowlite";
	# If the folder already exists cd into it and pull from master
	if [ -d $dir ]; then
		cd $dir;
		git pull origin master;
	# Else clone the repo
	elif [ ! -d $dir ]; then
		git clone https://github.com/MartinKaburu/stackoverflowlite.git && cd $dir;
	fi
}

# Configure Nginx
setupNginx() {
	echo "${red}---Setting up Nginx.---${reset}";
	available=/etc/nginx/sites-available/app
	enabled=/etc/nginx/sites-enabled/app
	default=/etc/nginx/sites-enabled/default
	# Remove the welcome to Nginx config file if it exists
	if [ -e $default ]; then
		sudo rm $default;
	fi
	# Link sites-enabled to sites-available if they haven't been linked yet
	if [ ! -f $enabled ] || [ ! -f $available ]; then
		sudo ln -s $available $enabled;
	fi
	# Enter the following configs to sites-enabled
	sudo bash -c "cat > $enabled <<END
server {
        server_name martinkaburu.info www.martinkaburu.info;
        location / {
                proxy_pass http://127.0.0.1:5000;
        }
}
END"
	# Restart Nginx
	sudo /etc/init.d/nginx restart;
}

# Install and Setup SSL for the domain names using certbot
setupSSL() {
	echo "${red}---Setting up Certbot.---${reset}";
  sudo apt-get install software-properties-common -y;
  sudo add-apt-repository universe -y;
  sudo add-apt-repository ppa:certbot/certbot -y;
  sudo apt-get update -y;
  sudo apt-get install python-certbot-nginx -y;
	sudo certbot --nginx  -d martinkaburu.info -d www.martinkaburu.info -m martinkaburu.m@gmail.com --agree-tos --non-interactive
	# Restart Nginx
	sudo /etc/init.d/nginx restart;
}

# Setup the applications virtual environment and install requirements
setupEnv() {
	echo "${red}---Setting up Environment.---${reset}";
	# If the venv folder doesn't exists create a new virtual environment and name it venv
	if [ ! -d venv ]; then
		virtualenv --python=python3 venv;
	fi
	# Activate the virtual environment
	source venv/bin/activate;
	echo "${red}---Installing requirements---${reset}";
	# Install requirements
	pip3 install -r requirements.txt;
}

# Create a script to start the application
createStartupApp() {
	echo "${red}---Creating Startapp---${reset}"
	sudo bash -c 'cat >/home/ubuntu/start.sh <<EOF
#! /bin/bash
file=/home/ubuntu/stackoverflowlite;
# If run.py is not in this directory cd into stackoverflowlite
if [ ! -e run.py ]; then
	cd /home/ubuntu/stackoverflowlite;
fi
# Pull latest changes from github, activate environment, install requirements and start app
git pull origin master;
source venv/bin/activate;
pip3 install -r requirements.txt && gunicorn app:APP -b localhost:5000;
EOF'
}

# Create the systemd service configuration
supervisorConfig() {
	conf=/etc/systemd/system/stackoverflowlite.service
	# If the configuration file does not exist touch it
	if [ ! -e $conf ]; then
		sudo touch $conf;
	fi
	# Cat this config to the file
	sudo bash -c 'cat >/etc/systemd/system/stackoverflowlite.service <<EOF
[Unit]
Description=stackoverflowlite
[Service]
WorkingDirectory=/home/ubuntu/stackoverflowlite/
ExecStart=/home/ubuntu/start.sh
[Install]
WantedBy=multi-user.target
EOF'
}

# Start the application
startApp(){
	echo "${red}---Starting app---${reset}"
	# Make the start script executable
	sudo chmod u+x /home/ubuntu/start.sh;
	# Update systemctl, enable stackoverflowlite.service to run on boot and start the service
	sudo systemctl daemon-reload;
	sudo systemctl enable stackoverflowlite.service;
	sudo systemctl start stackoverflowlite.service;
}

main() {
	updatePackages;
	cloneRepo;
	setupNginx;
	setupSSL;
	setupEnv;
	createStartupApp;
	supervisorConfig;
	startApp;
}

main;
#! /bin/bash -

# Declare tput red color and reset.
declare -r red=`tput setaf 1`;
declare -r reset=`tput sgr0`;

# Update packages and their dependancies.
updatePackages() {
	echo "${red}---Updating packages---${reset}";
	sudo apt-get update && sudo apt-get install nginx git python3 python3-pip virtualenv -y;
}

# Clone the repo and setup files.
cloneRepo() {
	echo "${red}---Cloning files---${reset}";
	dir="stackoverflowlite";
	# If the folder already exists cd into it and pull from master
	if [ -d $dir ]; then
		cd $dir;
		git pull origin master;
	# Else clone the repo
	elif [ ! -d $dir ]; then
		git clone https://github.com/MartinKaburu/stackoverflowlite.git && cd $dir;
	fi
}

# Configure Nginx
setupNginx() {
	echo "${red}---Setting up Nginx.---${reset}";
	available=/etc/nginx/sites-available/app
	enabled=/etc/nginx/sites-enabled/app
	default=/etc/nginx/sites-enabled/default
	# Remove the welcome to Nginx config file if it exists
	if [ -e $default ]; then
		sudo rm $default;
	fi
	# Link sites-enabled to sites-available if they haven't been linked yet
	if [ ! -f $enabled ] || [ ! -f $available ]; then
		sudo ln -s $available $enabled;
	fi
	# Enter the following configs to sites-enabled
	sudo bash -c "cat > $enabled <<END
server {
        server_name martinkaburu.info www.martinkaburu.info;
        location / {
                proxy_pass http://127.0.0.1:5000;
        }
}
END"
	# Restart Nginx
	sudo /etc/init.d/nginx restart;
}

# Install and Setup SSL for the domain names using certbot
setupSSL() {
	echo "${red}---Setting up Certbot.---${reset}";
  sudo apt-get install software-properties-common -y;
  sudo add-apt-repository universe -y;
  sudo add-apt-repository ppa:certbot/certbot -y;
  sudo apt-get update -y;
  sudo apt-get install python-certbot-nginx -y;
	sudo certbot --nginx  -d martinkaburu.info -d www.martinkaburu.info -m martinkaburu.m@gmail.com --agree-tos --non-interactive
	# Restart Nginx
	sudo /etc/init.d/nginx restart;
}

# Setup the applications virtual environment and install requirements
setupEnv() {
	echo "${red}---Setting up Environment.---${reset}";
	# If the venv folder doesn't exists create a new virtual environment and name it venv
	if [ ! -d venv ]; then
		virtualenv --python=python3 venv;
	fi
	# Activate the virtual environment
	source venv/bin/activate;
	echo "${red}---Installing requirements---${reset}";
	# Install requirements
	pip3 install -r requirements.txt;
}

# Create a script to start the application
createStartupApp() {
	echo "${red}---Creating Startapp---${reset}"
	sudo bash -c 'cat >/home/ubuntu/start.sh <<EOF
#! /bin/bash
file=/home/ubuntu/stackoverflowlite;
# If run.py is not in this directory cd into stackoverflowlite
if [ ! -e run.py ]; then
	cd /home/ubuntu/stackoverflowlite;
fi
# Pull latest changes from github, activate environment, install requirements and start app
git pull origin master;
source venv/bin/activate;
pip3 install -r requirements.txt && gunicorn app:APP -b localhost:5000;
EOF'
}

# Create the systemd service configuration
supervisorConfig() {
	conf=/etc/systemd/system/stackoverflowlite.service
	# If the configuration file does not exist touch it
	if [ ! -e $conf ]; then
		sudo touch $conf;
	fi
	# Cat this config to the file
	sudo bash -c 'cat >/etc/systemd/system/stackoverflowlite.service <<EOF
[Unit]
Description=stackoverflowlite
[Service]
WorkingDirectory=/home/ubuntu/stackoverflowlite/
ExecStart=/home/ubuntu/start.sh
[Install]
WantedBy=multi-user.target
EOF'
}

# Start the application
startApp(){
	echo "${red}---Starting app---${reset}"
	# Make the start script executable
	sudo chmod u+x /home/ubuntu/start.sh;
	# Update systemctl, enable stackoverflowlite.service to run on boot and start the service
	sudo systemctl daemon-reload;
	sudo systemctl enable stackoverflowlite.service;
	sudo systemctl start stackoverflowlite.service;
}

main() {
	updatePackages;
	cloneRepo;
	setupNginx;
	setupSSL;
	setupEnv;
	createStartupApp;
	supervisorConfig;
	startApp;
}

main;
