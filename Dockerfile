# syntax=docker/dockerfile:1

# ─────────────────────────────────────────────────────────────
# Stage 1 — base
# ─────────────────────────────────────────────────────────────
FROM ruby:4-slim AS base

WORKDIR /rails

ENV BUNDLE_PATH="/usr/local/bundle"

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libpq5 \
      libyaml-0-2 \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# ─────────────────────────────────────────────────────────────
# Stage 2 — build
# ─────────────────────────────────────────────────────────────
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      libpq-dev \
      libyaml-dev \
      git \
      nodejs \
      npm \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# 1) Install gems from our Gemfile first
COPY Gemfile Gemfile.loc[k] ./
RUN bundle install && \
    rm -rf "${BUNDLE_PATH}"/ruby/*/cache \
           "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# 2) Generate a full Rails app scaffold in a temp dir,
#    then copy only the boilerplate files we need
RUN bundle exec rails new /tmp/scaffold \
      --database=postgresql \
      --css=tailwind \
      --javascript=importmap \
      --skip-bundle \
      --skip-git \
      --skip-test \
      --quiet

# 3) Copy scaffold boilerplate (bin/*, config/boot.rb, etc.)
#    Our own files will overwrite these in step 4
RUN cp -r /tmp/scaffold/bin         /rails/bin && \
    cp -r /tmp/scaffold/config.ru   /rails/config.ru && \
    cp    /tmp/scaffold/Rakefile    /rails/Rakefile && \
    cp    /tmp/scaffold/config/boot.rb        /rails/config/boot.rb && \
    cp    /tmp/scaffold/config/environment.rb /rails/config/environment.rb && \
    cp -n /tmp/scaffold/config/application.rb /rails/config/application.rb 2>/dev/null || true && \
    cp -rn /tmp/scaffold/app/assets           /rails/app/assets 2>/dev/null || true && \
    cp -rn /tmp/scaffold/public               /rails/public 2>/dev/null || true && \
    cp -rn /tmp/scaffold/log                  /rails/log 2>/dev/null || true && \
    cp -rn /tmp/scaffold/tmp                  /rails/tmp 2>/dev/null || true && \
    cp -rn /tmp/scaffold/storage              /rails/storage 2>/dev/null || true && \
    rm -rf /tmp/scaffold

# 4) Copy our custom app files (overwrite scaffold where needed)
COPY . .

# ─────────────────────────────────────────────────────────────
# Stage 3 — development  (docker-compose target)
# ─────────────────────────────────────────────────────────────
FROM build AS development

ENV RAILS_ENV=development

RUN chmod +x bin/* 2>/dev/null || true

EXPOSE 3000
