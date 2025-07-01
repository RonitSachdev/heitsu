# Heitsu - Rails 8.0.2 with Docker

A Rails 8.0.2 application running with Docker and PostgreSQL.

## Setup

### Prerequisites
- Docker
- Docker Compose

### Getting Started

1. **Build and start the containers:**
   ```bash
   docker-compose up -d
   ```

2. **Create the database:**
   ```bash
   docker-compose exec app rails db:create
   docker-compose exec app rails db:migrate
   ```

3. **Access the application:**
   - Open your browser and navigate to `http://localhost:3000`

### Development

- **Run Rails commands:**
  ```bash
  docker-compose exec app rails [command]
  ```

- **Access Rails console:**
  ```bash
  docker-compose exec app rails console
  ```

- **Run tests:**
  ```bash
  docker-compose exec app rails test
  ```

- **Stop the containers:**
  ```bash
  docker-compose down
  ```

### Features

- **Rails 8.0.2** with latest features
- **PostgreSQL** database
- **Docker** containerization
- **Importmap** for JavaScript
- **Turbo & Stimulus** for modern web interactions
- **Solid Cache, Queue & Cable** for performance

### Services

- **app**: Rails application (port 3000)
- **db**: PostgreSQL database (port 5432)

The application is configured to run in development mode with hot reloading enabled.
