import aiomysql

async def get_database_connection():
    connection = await aiomysql.connect(
        host='mysql-db',
        port=3306,
        user='admin',
        password='passwd',
        db='zbd',
        autocommit=True
    )
    return connection