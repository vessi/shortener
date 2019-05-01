FROM ruby:2.6.2-alpine

RUN apk update && apk add build-base nodejs yarn
RUN apk add --update tzdata
RUN gem install bundler

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs
COPY package.json yarn.lock ./
RUN yarn install --check-files

COPY . .

CMD puma -C config/puma.rb
