FROM ruby:3.0.2-slim-bullseye AS assets

WORKDIR /app

RUN bash -c "set -o pipefail && apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl git libpq-dev \
  && curl -sSL https://deb.nodesource.com/setup_16.x | bash - \
  && curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y --no-install-recommends nodejs yarn \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && useradd --create-home ruby \
  && mkdir /node_modules && chown ruby:ruby -R /node_modules /app"

USER ruby

COPY --chown=ruby:ruby Gemfile* ./
RUN bundle install --jobs "$(nproc)"

COPY --chown=ruby:ruby package.json *yarn* ./
RUN yarn install

ARG RAILS_ENV="production"
ARG NODE_ENV="production"
ENV RAILS_ENV="${RAILS_ENV}" \
    NODE_ENV="${NODE_ENV}" \
    PATH="${PATH}:/home/ruby/.local/bin:/node_modules/.bin" \
    USER="ruby"

COPY --chown=ruby:ruby . .

RUN if [ "${RAILS_ENV}" != "development" ]; then \
  SECRET_KEY_BASE=dummyvalue rails assets:precompile; fi

CMD ["bash"]

###############################################################################

FROM ruby:3.0.2-slim-bullseye AS app

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl libpq-dev supervisor vim nginx \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && useradd --create-home ruby \
  && chown ruby:ruby -R /app

#Config for Cloudwatch logs
RUN curl -o /root/amazon-cloudwatch-agent.deb https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/arm64/latest/amazon-cloudwatch-agent.deb
RUN dpkg -i -E /root/amazon-cloudwatch-agent.deb
RUN mkdir /app/.aws
RUN touch /app/.aws/credentials
RUN touch /app/.aws/config
RUN echo "[AmazonCloudWatchAgent]" >> /app/.aws/config
RUN echo "output = text" >> /app/.aws/config
RUN echo "region = us-east-2" >> /app/.aws/config
RUN echo "[AmazonCloudWatchAgent]" >> /app/.aws/credentials
RUN echo "aws_access_key_id = $CW_KEY" >> /app/.aws/credentials
RUN echo "aws_secret_access_key = $CW_SECRET" >> /app/.aws/credentials
COPY docker/cloudwatch-agent-config.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
RUN echo "[credentials]" >> /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml
RUN echo '    shared_credential_file = "/app/.aws/credentials"' >> /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml
RUN echo '    shared_credential_profile="AmazonCloudWatchAgent"' >> /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml


RUN touch /var/run/nginx.pid
RUN chmod -R 777 /var/run/*
RUN chmod -R 777 /var/log/nginx/*
RUN chmod -R 777 /var/lib/*

USER ruby

COPY --chown=ruby:ruby bin/ ./bin
RUN chmod 0755 bin/*

ARG RAILS_ENV="production"
ENV RAILS_ENV="${RAILS_ENV}" \
    PATH="${PATH}:/home/ruby/.local/bin" \
    USER="ruby"

COPY --chown=ruby:ruby --from=assets /usr/local/bundle /usr/local/bundle
COPY --chown=ruby:ruby --from=assets /app/public /public
COPY --chown=ruby:ruby . .

COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/sovocal-nginx.conf /etc/nginx/conf.d/
COPY docker/supervisord.conf /etc/supervisord.conf

ENTRYPOINT ["/app/bin/docker-entrypoint-web"]

EXPOSE 3000

CMD ["rails", "s"]