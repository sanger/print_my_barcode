FROM starefossen/ruby-node
ENV BUNDLER_VERSION=2.1.4

RUN apt-get update -qq && apt-get install -y
RUN apt-get -y install git vim

WORKDIR /code

COPY Gemfile /code
COPY Gemfile.lock /code

ADD . /code/

RUN gem install bundler
RUN bundle install

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
