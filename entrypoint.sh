#!/bin/bash
set -e

echo "Starting Apache Ranger Admin..."

# Wait for PostgreSQL
until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER"; do
  echo "Postgres not ready at $DB_HOST:$DB_PORT - retrying..."
  sleep 3
done

# Initialize DB once
if [ ! -f ${RANGER_HOME}/.db_initialized ]; then
    echo "Initializing Ranger Database..."
    cd ${RANGER_HOME}/db
    python3 db_setup.py install || exit 1
    touch ${RANGER_HOME}/.db_initialized
fi

echo "Starting Ranger Admin service..."
cd ${RANGER_HOME}/ews
./ranger-admin-services.sh start

echo "Tailing logs..."
tail -f /opt/ranger/ews/logs/*.log
