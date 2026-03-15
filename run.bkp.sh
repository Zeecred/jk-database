#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

if ! [ -x "$(command -v python3)" ]; then
	echo "ERROR: python3 command not found. Please install Python 3 first before running this script. ABORTING."
	exit 1
fi

PYTHON_VERSION="$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
PYTHON_VENV_PACKAGE="python${PYTHON_VERSION}-venv"

INSTALL_REQUIRED=false
echo "Loading existing virtual environment."
if [ ! -f .venv/bin/activate ]; then
    sudo apt install -y "$PYTHON_VENV_PACKAGE"
	python3 -m venv .venv
	INSTALL_REQUIRED=true
fi

if ! dpkg -l | grep -q libmysqlclient-dev; then
	sudo apt-get update
	sudo apt-get install -y pkg-config build-essential python3-dev default-libmysqlclient-dev
	sudo apt-get install libmysqlclient-dev -y
	INSTALL_REQUIRED=true
fi

if [ ! -f ../.env ] && [ ! -f my-credentials.json ]; then
	echo "***********************************************************************"
	echo "ERROR: neither ../.env nor my-credentials.json was found. ABORTING."
	echo "***********************************************************************"
	exit 1
fi

source .venv/bin/activate
if $INSTALL_REQUIRED; then
    python3 -m pip install -U pip setuptools wheel
fi
python3 -m pip install -r requirements.txt
python3 create_databases.py
python3 create_users.py
