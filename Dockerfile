FROM ruby:3.3.7
ENV BUNDLER_VERSION=2.2.6

RUN apt-get update -qq && apt-get install -y
RUN apt-get -y install cups-client cups-bsd
RUN apt-get -y install expect

WORKDIR /code

COPY Gemfile /code
COPY Gemfile.lock /code

ADD . /code/

RUN gem install bundler
RUN bundle install

RUN mkdir -p tmp/pids

COPY create-cups-printer.sh /
RUN ["chmod", "+x", "/create-cups-printer.sh"]

COPY docker-entrypoint.sh /
RUN ["chmod", "+x", "/docker-entrypoint.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
