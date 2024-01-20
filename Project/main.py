from dotenv import load_dotenv
import os

from MYSQLConnector.connector import MYSQLConnector


load_dotenv()


if __name__ == '__main__':
    # EXAMPLE USAGE
    db_connector = MYSQLConnector(
        os.getenv('DB_HOST'),
        os.getenv('DB_USER'),
        os.getenv('DB_PASSWORD'),
        os.getenv('DB_NAME')
    )

    # Querring (there are 3 workers pre-created)
    # Fetching workers
    workers_df = db_connector.get_all_records('Worker')
    print(workers_df.head())

    # Adding workers (from fetched dataset)
    db_connector.add_data('Worker', workers_df)

    # Fetching new workers to check if they were added
    workers_df = db_connector.get_all_records('Worker')
    print(workers_df.head(50))
