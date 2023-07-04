FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs vim
RUN mkdir /imazuru
WORKDIR /imazuru
COPY Gemfile /imazuru/Gemfile
COPY Gemfile.lock /imazuru/Gemfile.lock
RUN bundle install
RUN git config --global --add safe.directory /imazuru
COPY . /imazuru