FROM python:3.8-slim-buster

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=true

# Using a different directory than /usr/src/app to allow volume mounting of code to /usr/src/app for local development
WORKDIR /opt/setup

RUN apt-get -y update && \
    apt-get install -y --fix-missing \
        build-essential \
        pkg-config

RUN pip install --upgrade poetry
COPY . /opt/setup
RUN poetry install --no-dev --no-interaction --no-ansi

FROM python:3.8-slim-buster

ENV WORKDIR=/usr/src/app \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
WORKDIR $WORKDIR

# Copy the virtual environment from the first stage so we can set the Python path to it's packages
# avoiding the need to install any of the dependencies
COPY --from=0 /opt/setup/.venv /opt/setup/.venv
# Set additional Python paths to expose libraries installed in previous stages
ENV PYTHONPATH="/opt/setup/.venv/lib/python3.8/site-packages:$PYTHONPATH"
ENV PATH="$PATH:/opt/setup/.venv/bin"

COPY huanchh $WORKDIR/huanchh

EXPOSE 80

CMD uvicorn huanchh.sandbox.api:app --host 0.0.0.0 --port 80