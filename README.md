# 🔥 BookMangal

A web application for booking a mangal (BBQ grill) for outdoor picnics. Built with Rails 8, Hotwire, and Tailwind CSS v4.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend | Ruby 4, Rails 8.1 |
| Frontend | Hotwire (Turbo + Stimulus), Tailwind CSS v4 |
| Auth | Devise |
| Database | PostgreSQL 18 |
| Testing | RSpec, FactoryBot, Shoulda Matchers |
| Linting | RuboCop (rails, rspec, performance) |
| Infrastructure | Docker, Docker Compose |

## Features

- **Weekly calendar** — view all bookings for the current week at a glance
- **Week navigation** — browse past and future weeks
- **Create booking** — pick a date and time slot (08:00–22:00)
- **Edit / cancel booking** — modify or cancel your own reservations
- **Overlap protection** — the system prevents double-bookings
- **User profile** — update name, email, and password
- **Authentication** — sign up and sign in via email/password (Devise)
- **Responsive** — works on mobile and desktop

---

## Getting Started

### Prerequisites

- Docker Desktop

### Run with Docker

```bash
# 1. Clone the repo
git clone <repo-url>
cd bookmangal

# 2. Start the stack
docker compose up --build

# 3. Seed demo data (first run only)
docker compose exec app bundle exec rails db:seed
```

App is available at **http://localhost:3000**

### Demo accounts (after seeding)

| Email | Password |
|-------|----------|
| ivan@example.com | password123 |
| olena@example.com | password123 |

---

## Local Development (without Docker)

### Prerequisites

- Ruby 4.0+
- PostgreSQL 18
- Node.js (for Tailwind CSS)

```bash
# Install dependencies
bundle install

# Configure environment
cp .env.example .env
# Edit .env with your local DB credentials

# Set up database
rails db:create db:migrate db:seed

# Start the dev server
bin/rails server
```

---

## Testing

```bash
# Run all specs
bundle exec rspec

# Run with documentation format
bundle exec rspec --format documentation

# Run only model specs
bundle exec rspec spec/models/

# Run only controller specs
bundle exec rspec spec/controllers/
```

### Run tests in Docker

```bash
docker compose -f docker-compose.yml -f docker-compose.test.yml run --rm test
```

---

## Linting

```bash
# Check for offenses
bundle exec rubocop

# Auto-fix safe offenses
bundle exec rubocop -a

# Auto-fix all offenses
bundle exec rubocop -A
```

---

## Project Structure

```
bookmangal/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── bookings_controller.rb   # CRUD + cancel action
│   │   ├── pages_controller.rb      # Home calendar view
│   │   ├── profiles_controller.rb   # User profile update
│   │   └── users/
│   │       ├── registrations_controller.rb
│   │       └── sessions_controller.rb
│   ├── models/
│   │   ├── booking.rb               # Overlap, hours, status enum
│   │   └── user.rb                  # Devise + initials helper
│   ├── views/
│   │   ├── layouts/application.html.erb
│   │   ├── pages/home.html.erb      # Weekly calendar (desktop grid + mobile list)
│   │   ├── bookings/                # new, edit, _form
│   │   ├── profiles/edit.html.erb
│   │   └── devise/                  # sessions, registrations
│   ├── assets/
│   │   ├── tailwind/application.css # Tailwind v4 entry point
│   │   └── builds/                  # Compiled CSS output (git-ignored)
│   └── javascript/
│       └── controllers/
│           └── mobile_menu_controller.js  # Stimulus
├── config/
│   ├── routes.rb
│   ├── database.yml
│   └── initializers/devise.rb
├── db/
│   ├── migrate/
│   │   ├── 20240101000001_devise_create_users.rb
│   │   └── 20240101000002_create_bookings.rb
│   └── seeds.rb
├── spec/
│   ├── models/
│   │   ├── user_spec.rb
│   │   └── booking_spec.rb
│   ├── controllers/
│   │   ├── bookings_controller_spec.rb
│   │   └── pages_controller_spec.rb
│   ├── factories/
│   │   ├── users.rb
│   │   └── bookings.rb
│   └── support/
│       ├── factory_bot.rb
│       ├── shoulda_matchers.rb
│       └── database_cleaner.rb
├── Dockerfile
├── docker-compose.yml
├── docker-compose.test.yml
└── .env.example
```

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_HOST` | `localhost` | PostgreSQL host |
| `DB_PORT` | `5432` | PostgreSQL port |
| `DB_USERNAME` | `bookmangal` | PostgreSQL user |
| `DB_PASSWORD` | `password` | PostgreSQL password |
| `SECRET_KEY_BASE` | — | Rails secret key (required in production) |
| `RAILS_ENV` | `development` | Rails environment |

---

## Booking Rules

- Operating hours: **08:00 – 22:00**
- Overlapping bookings are **not allowed**
- Past dates cannot be booked
- Only the booking owner can edit or cancel their reservation
