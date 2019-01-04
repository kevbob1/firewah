FROM ruby:2.4-slim

# start setting up the app
ENV APP_HOME /myapp
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
EXPOSE 3000
ENV RAILS_ENV production
ENV RACK_ENV production
# needed for application config
ENV REDIS_HOST ""

RUN set -x \
    && apt-get update  \
    && apt-get install -y \
       build-essential \
       git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
CMD foreman start -p 3000
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install \ 
      -j "$(getconf _NPROCESSORS_ONLN)" --retry 5 --without development test

ADD . $APP_HOME

