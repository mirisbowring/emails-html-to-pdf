FROM python:3.9-slim

RUN apt-get update && apt-get -y install wget
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb
RUN apt-get install -y ./wkhtmltox_0.12.6-1.buster_amd64.deb
RUN rm -rf /var/lib/apt/lists/* && rm wkhtmltox_0.12.6-1.buster_amd64.deb

ENV PYTHONPATH=${PYTHONPATH}:${PWD}
RUN pip3 install poetry

RUN mkdir /app
COPY /src /app
COPY pyproject.toml /app
COPY runner.sh /app/runner.sh
RUN chmod +x /app/runner.sh
WORKDIR /app

RUN poetry config virtualenvs.create false
RUN poetry install --no-dev

ENTRYPOINT ["/app/runner.sh"]
