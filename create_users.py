import json
import mysql.connector

def create_users():
    with open('users.json') as file:
        data = json.load(file)

    with open('my-credentials.json') as file:
        credentials = json.load(file)

    db = mysql.connector.connect(
        user=credentials['username'],
        password=credentials['password'],
        host=credentials['host'],
        port=credentials['port'],
        database='mysql'
    )

    cursor = db.cursor()

    for user in data['users']:
        query = "SELECT COUNT(*) FROM mysql.user WHERE User = '{}'".format(user['name'])
        cursor.execute(query)
        result = cursor.fetchone()
        if result[0] == 0:
            print(f"Creating user: {user['name']}")
            query = "CREATE USER '{}'@'{}' IDENTIFIED BY '{}'".format(
                user['name'], user['host'], user['password'])
            cursor.execute(query)

            for privilege in user['privileges']:
                query = "GRANT {} ON {}.* TO '{}'@'{}'".format(
                    ', '.join(privilege['privileges']),
                    privilege['database'],
                    user['name'],
                    user['host']
                )
                cursor.execute(query)

    db.commit()
    cursor.close()
    db.close()


if __name__ == "__main__":
    create_users()