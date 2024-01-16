FROM python:3.10.2-slim-buster AS base

ENV PYTHONUNBUFFERED=1

WORKDIR /src

RUN apt-get update

COPY ./src .

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txr

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
