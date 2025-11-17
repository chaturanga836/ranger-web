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
    echo "--- Initializing Ranger Database: Running db_setup.py ---" # Added confirmation
    cd ${RANGER_HOME}/db
    python3 db_setup.py install || exit 1
    touch ${RANGER_HOME}/.db_initialized
fi

echo "Starting Ranger Admin service..."
cd ${RANGER_HOME}/ews
# Run the startup script in the background
./ranger-admin-services.sh start

echo "Tailing logs... (Press Ctrl+C to stop)"
# Tail a specific log file or the output of the server process if possible.
# Keeping the original for now, but be aware of potential issues if no logs exist.
tail -f /opt/ranger/ews/logs/*.log