import json
import mysql.connector
import socket
import time


FORBIDDEN_PRIVILEGES = {"DROP", "ALL", "ALL PRIVILEGES"}


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
            print(f"Trying to connect to {host}:{port}. Count down: {count_down}")
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
    print(sql)
    cursor.execute(sql)


def create_users():
    with open('users.json') as file:
        data = json.load(file)
    with open('my-credentials.json') as file:
        credentials = json.load(file)

    print("Waiting for MySQL to start...")
    time.sleep(5)
    wait_for_port_open(credentials['host'], credentials['port'])

    db = mysql.connector.connect(
        user=credentials['username'],
        password=credentials['password'],
        host=credentials['host'],
        port=credentials['port'],
        database='mysql'
    )

    cursor = db.cursor()

    for user in data['users']:
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

    exec_sql(cursor, "FLUSH PRIVILEGES")

    db.commit()
    cursor.close()
    db.close()


if __name__ == "__main__":
    create_users()
