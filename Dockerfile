FROM ruby:2.6.2-alpine

RUN apk update && apk add build-base nodejs yarn
RUN apk add --update tzdata
RUN gem install bundler

RUN mkdir /app
WORKDIR /app

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs --without development test
COPY package.json yarn.lock ./
RUN yarn install --check-files

COPY . .

RUN rake assets:precompile

CMD puma -C config/puma.rb
