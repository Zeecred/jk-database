# 1) Fix mysqlclient build tooling (optional unless you really need mysqlclient)
sudo apt-get update
sudo apt-get install -y pkg-config build-essential python3-dev default-libmysqlclient-dev

# 2) Install the connector you are actually importing
source .venv/bin/activate
python -m pip install -U pip setuptools wheel
python -m pip install mysql-connector-python