import json
import mysql.connector

with open('databases.json') as f:
    databases = json.load(f)

with open('my-credentials.json') as file:
    credentials = json.load(file)

cnx = mysql.connector.connect(
    user=credentials['username'],
    password=credentials['password'],
    host=credentials['host'],
    port=credentials['port'],
    database='mysql'
)

cursor = cnx.cursor()

for db in databases:
    sql = f"CREATE DATABASE IF NOT EXISTS {db} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    print(sql)
    cursor.execute(sql)

cursor.close()
cnx.close()

