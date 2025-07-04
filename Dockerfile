# Stage 1: Build React Frontend
FROM node:18 as frontend

WORKDIR /app/frontend

COPY ./Frontend/ecommerce_inventory/ .

RUN npm install
RUN npm run build


# Stage 2: Build Django Backend
FROM python:3.11-slim as backend

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    default-libmysqlclient-dev \
    netcat \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies
COPY ./Backend/EcommerceInventory/ ./Backend/EcommerceInventory/
RUN pip install --upgrade pip
RUN pip install -r ./Backend/EcommerceInventory/requirements.txt

# Copy frontend build into Django static files directory
COPY --from=frontend /app/frontend/build ./Backend/EcommerceInventory/static/
COPY --from=frontend /app/frontend/build/index.html ./Backend/EcommerceInventory/EcommerceInventory/templates/index.html

# Set working directory to Django app
WORKDIR /app/Backend/EcommerceInventory

# Expose Django port
EXPOSE 8000

# Entry point script (see below)
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
