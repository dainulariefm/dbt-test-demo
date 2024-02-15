# Use an official Python runtime as the base image
FROM python:3.8

# Set environment variables
ENV AIRFLOW_HOME=/usr/local/airflow

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Apache Airflow
RUN pip install "apache-airflow[celery]==2.8.1" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.8.1/constraints-3.8.txt"

# Install dbt-core
RUN pip install dbt-core \
dbt-postgres \
dbt-bigquery

# Initialize Airflow database
RUN airflow db migrate

RUN airflow users create -r Admin -u admin -e admin@example.com -f admin -l user -p test


# Copy the rest of the application code to the working directory
WORKDIR ${AIRFLOW_HOME}
COPY . .

# Expose the Airflow webserver and scheduler ports
EXPOSE 8080 8793

# Command to start Airflow webserver and scheduler
CMD ["airflow", "webserver", "-p", "8080"]

