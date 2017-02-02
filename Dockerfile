FROM ruby:2.4.0

# setup the app dir
ENV APP_ROOT /app
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

# bundle gems first to take advantage of layer caching
ENV BUNDLE_GEMFILE=$APP_ROOT/Gemfile \
    BUNDLE_JOBS=2
ADD ./app/Gemfile* $APP_ROOT/
RUN bundle install

# copy over source files
ADD ./app $APP_HOME

# launch the app
CMD bundle exec rackup --host 0.0.0.0 -p 5000
EXPOSE 5000
