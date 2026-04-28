# 🔥 BookMangal

Додаток для бронювання мангалу. Rails 8 + Hotwire + Tailwind CSS + PostgreSQL.

## Стек

- **Ruby on Rails 8** + Hotwire (Turbo + Stimulus)
- **PostgreSQL 16**
- **Devise** — авторизація
- **Tailwind CSS** — стилізація
- **RSpec** + FactoryBot + Shoulda Matchers — тести
- **Rubocop** — лінтинг
- **Docker** + Docker Compose — контейнеризація

---

## Локальний запуск

### Передумови
- Ruby 3.2+
- PostgreSQL 16
- Node.js 20+

```bash
git clone <repo>
cd bookmangal

cp .env.example .env        # налаштуй змінні

bundle install
rails db:create db:migrate db:seed

bin/dev                     # http://localhost:3000
```

**Тестові акаунти** (після `db:seed`):
- `ivan@example.com` / `password123`
- `olena@example.com` / `password123`

---

## Docker

### Development

```bash
cp .env.example .env

docker compose up --build
# http://localhost:3000

# Міграції (перший запуск)
docker compose exec app rails db:migrate db:seed
```

### Тести в Docker

```bash
docker compose -f docker-compose.yml -f docker-compose.test.yml run --rm test
```

---

## Тести

```bash
bundle exec rspec                        # всі тести
bundle exec rspec spec/models/           # тільки моделі
bundle exec rspec spec/controllers/      # контролери
bundle exec rspec --format documentation # детальний вивід
```

## Лінтинг

```bash
bundle exec rubocop                      # перевірка
bundle exec rubocop -a                   # авто-виправлення безпечних
bundle exec rubocop -A                   # виправлення всього
```

---

## Структура

```
app/
  controllers/
    application_controller.rb
    bookings_controller.rb
    pages_controller.rb          # календар (головна)
    profiles_controller.rb
    users/
      registrations_controller.rb
      sessions_controller.rb
  models/
    user.rb
    booking.rb
  views/
    layouts/application.html.erb
    pages/home.html.erb          # тижневий календар
    bookings/                    # new, edit, _form
    profiles/edit.html.erb
    devise/                      # sessions, registrations
  javascript/controllers/
    mobile_menu_controller.js    # Stimulus

spec/
  models/
    user_spec.rb
    booking_spec.rb
  controllers/
    bookings_controller_spec.rb
    pages_controller_spec.rb
  factories/
    users.rb
    bookings.rb
  support/
    factory_bot.rb
    shoulda_matchers.rb
    database_cleaner.rb
```
