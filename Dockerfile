FROM ruby:2.5.8

RUN apt-get update && apt-get install --fix-missing -y \
  build-essential \
  locales

RUN gem install bundler -v 1.17.3

RUN mkdir /app

ENV BUNDLE_GEMFILE=/app/Gemfile \
  BUNDLE_JOBS=20 \
  BUNDLE_PATH=/bundle

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

WORKDIR /app

RUN bundle install

ENV PATH="/app/bin:${PATH}"

ADD . /app
