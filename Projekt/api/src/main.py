from fastapi import FastAPI, Depends
from database import get_database_connection

app = FastAPI()

async def get_db():
    db = await get_database_connection()
    try:
        yield db
    finally:
        db.close()

@app.get("/")
async def read_root(db: aiomysql.Connection = Depends(get_db)):
    # Your database queries or operations here
    return {"message": "Hello, FastAPI and MySQL!"}