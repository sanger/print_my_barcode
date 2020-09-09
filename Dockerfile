FROM starefossen/ruby-node
ENV BUNDLER_VERSION=2.1.4

RUN apt-get update -qq && apt-get install -y
RUN apt-get -y install cups-client
RUN apt-get install expect

WORKDIR /code

COPY Gemfile /code
COPY Gemfile.lock /code

ADD . /code/

RUN gem install bundler
RUN bundle install

COPY docker-entrypoint.sh /
RUN ["chmod", "+x", "/docker-entrypoint.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

