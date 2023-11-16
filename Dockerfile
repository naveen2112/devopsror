FROM ruby:3.0.2
RUN gem install rails -v 6.1.4
RUN apt update -y && \ 
apt install -y git-core curl zlib1g-dev build-essential \
libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \
libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common \
libffi-dev libgdbm-dev libncurses5-dev automake libtool bison libffi-dev && \
apt-get install libpq-dev -y && \
apt install -y nodejs npm && \
npm install -g yarn
WORKDIR /var/www/
RUN git clone https://github.com/naveen2112/devopsror.git 
WORKDIR /var/www/devopsror
RUN bundle install
ENV RAILS_ENV=production \
    DATABASE_NAME=postgres \
    DATABASE_USERNAME=postgres \
    DATABASE_PASSWORD=admin123 \
    DATABASE_HOST=ror.cfetpjdspyv9.ap-south-1.rds.amazonaws.com \
    DATABASE_PORT=5432
RUN export SECRET_KEY_BASE=$(bundle exec rake secret) && echo "export SECRET_KEY_BASE=$SECRET_KEY_BASE" >> ~/.bashrc
RUN rake db:create
RUN rake db:migrate
RUN rake assets:precompile
EXPOSE 3000
CMD ["bash", "-c", "RAILS_ENV=production bundle exec rails s"]
