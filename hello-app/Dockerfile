FROM rubylang/ruby:2.6.3-bionic

ENV TZ Asia/Tokyo

RUN apt update -y && \
    apt install -y \
      libmysqlclient-dev \
      mysql-client \
      nodejs

COPY Gemfile /tmp/

RUN cd /tmp && \
    bundle install --path /bundle && \
    rm -f /bundle/ruby/*/cache/*.gem && \
    mkdir /app && \
    mv Gemfile.lock .bundle /app/

COPY . /app

WORKDIR /app

CMD ["/app/init.sh"]
