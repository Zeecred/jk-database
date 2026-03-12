import json
import mysql.connector
import socket
import time
from datetime import datetime

from db_credentials import load_db_credentials
from db_grants import ensure_can_manage_users


FORBIDDEN_PRIVILEGES = {"ALL", "ALL PRIVILEGES"}


def log(message):
    print(message, flush=True)

def sanitize_privileges(privileges):
    cleaned = []
    removed = []

    for privilege in privileges:
        normalized = str(privilege).strip().upper()
        if not normalized:
            continue
        if normalized in FORBIDDEN_PRIVILEGES:
            removed.append(normalized)
            continue
        cleaned.append(normalized)

    return cleaned, removed


def wait_for_port_open(host, port):
    count_down = 90
    while True:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            log(f"Trying to connect to {host}:{port}. Count down: {count_down}")
            s.connect((host, int(port)))
            s.close()
            break
        except socket.error:
            pass
        count_down -= 1
        if count_down == 0:
            raise Exception(f"Could not connect to {host}:{port}")
        time.sleep(0.5)


def exec_sql(cursor, sql):
    log(sql)
    cursor.execute(sql)


def collect_required_schema_privileges(users):
    required = {}
    for user in users:
        for privilege in user.get("privileges", []):
            database_name = privilege["database"]
            safe_privileges, _ = sanitize_privileges(privilege.get("privileges", []))
            if not safe_privileges:
                continue
            required.setdefault(database_name, set()).update(safe_privileges)
    return required


def create_users():
    log(f"create_users.py started at {datetime.utcnow().isoformat()}Z")
    with open('users.json') as file:
        data = json.load(file)
    credentials = load_db_credentials()

    users = data.get('users', [])
    log(f"Loaded {len(users)} user entries from users.json")
    log("Waiting for MySQL to start...")
    time.sleep(5)
    wait_for_port_open(credentials['host'], credentials['port'])
    log(
        "Connecting with mysql.connector "
        f"host={credentials['host']} port={credentials['port']} "
        f"user={credentials['username']} database=mysql",
    )

    db = mysql.connector.connect(
        user=credentials['username'],
        password=credentials['password'],
        host=credentials['host'],
        port=credentials['port'],
        database='mysql'
    )

    cursor = db.cursor()
    ensure_can_manage_users(cursor, collect_required_schema_privileges(users))

    for user in users:
        user_name = user['name']
        user_host = user['host']
        user_password = user['password']
        user_id = f"'{user_name}'@'{user_host}'"

        exec_sql(cursor, f"DROP USER IF EXISTS {user_id}")
        exec_sql(cursor, f"CREATE USER {user_id} IDENTIFIED BY '{user_password}'")

        for privilege in user['privileges']:
            database_name = privilege['database']
            db_scope = f"`{database_name}`.*"

            safe_privileges, _ = sanitize_privileges(privilege['privileges'])

            if not safe_privileges:
                continue

            grant_query = "GRANT {} ON {} TO {}".format(
                ', '.join(safe_privileges), db_scope, user_id
            )
            exec_sql(cursor, grant_query)

    db.commit()
    cursor.close()
    db.close()
    log("create_users.py finished successfully")


if __name__ == "__main__":
    create_users()
