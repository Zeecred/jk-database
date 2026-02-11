#!/bin/bash
if [ ! -d .venv ]; then
	python3 -m venv .venv
fi

if ! [ -x "$(command -v python3)" ]; then
	echo "ERROR: python3 command not found. Please install Python 3 first before running this script. ABORTING."
	exit 1
fi

echo "Loading existing virtual environment."
if [ ! -d .venv ]; then
	python3 -mvenv .venv
fi

INSTALL_REQUIRED=false
dpkg -l | grep libmysqlclient-dev
if [ $? -ne 0 ]; then
	sudo apt-get update
	sudo apt-get install -y pkg-config build-essential python3-dev default-libmysqlclient-dev
	sudo apt-get install libmysqlclient-dev -y
	INSTALL_REQUIRED=true
fi

if [ ! -f my-credentials.json ]; then
	echo "**************************************************************"
	echo "ERROR: my-credentials.json not found. Please create it first before running this script. ABORTING."
	echo "**************************************************************"
	exit 1
fi

source .venv/bin/activate
if $INSTALL_REQUIRED; then
    python -m pip install -U pip setuptools wheel
fi
pip install -r requirements.txt
python3 create_databases.py
python3 create_users.py
