#!/bin/sh

# Wait for DB (optional: if using Docker Compose)
if [ "$DB_HOST" = "ecommerce.coh6qc8cygwn.us-east-1.rds.amazonaws.com" ]; then
  echo "Waiting for MySQL..."
  while ! nc -z $DB_HOST $DB_PORT; do
    sleep 1
  done
  echo "MySQL started"
fi

# Run migrations
python manage.py migrate

# Collect static files
python manage.py collectstatic --no-input

# Start Gunicorn
gunicorn EcommerceInventory.wsgi:application --bind 0.0.0.0:8000
