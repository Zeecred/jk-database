import json
import mysql.connector


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
            database_name = privilege['database']

            # Never allow DROP for common users (covers TABLE and DATABASE in db scope).
            revoke_query = "REVOKE DROP ON `{}`.* FROM '{}'@'{}'".format(
                database_name,
                user['name'],
                user['host']
            )
            try:
                cursor.execute(revoke_query)
            except mysql.connector.Error:
                # User may have no DROP privilege yet; safe to continue.
                pass

            safe_privileges, removed_privileges = sanitize_privileges(
                privilege['privileges']
            )
            if removed_privileges:
                print(
                    "Removing forbidden privileges from {}@{} on {}: {}".format(
                        user['name'],
                        user['host'],
                        database_name,
                        ', '.join(sorted(set(removed_privileges)))
                    )
                )

            if not safe_privileges:
                print(
                    "Skipping GRANT for {}@{} on {} (no allowed privileges).".format(
                        user['name'],
                        user['host'],
                        database_name
                    )
                )
                continue

            grant_query = "GRANT {} ON `{}`.* TO '{}'@'{}'".format(
                ', '.join(safe_privileges),
                database_name,
                user['name'],
                user['host']
            )
            cursor.execute(grant_query)

    db.commit()
    cursor.close()
    db.close()


if __name__ == "__main__":
    create_users()
