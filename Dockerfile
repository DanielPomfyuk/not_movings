FROM ruby:slim-stretch
RUN apt-get update
RUN apt-get install -y build-essential patch ruby-dev zlib1g-dev liblzma-dev libsqlite3-dev sqlite3 nodejs
COPY . /not_movings/
WORKDIR /not_movings/
RUN bundle install
CMD ["rails","s"]