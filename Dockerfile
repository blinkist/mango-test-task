FROM ruby:3.1.2 as dev
WORKDIR /app

FROM dev as live
ENV RAILS_ENV=production

RUN bundle install

EXPOSE 3000
CMD rails s -b 0.0.0.0
