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
source .venv/bin/activate
pip install -r requirements.txt
python3 create_databases.py 
python3 create_users.py

