FROM odaniait/passenger-docker:master
MAINTAINER Mike Petersen <mike@odania-it.de>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Remove the default site
RUN rm /etc/nginx/sites-enabled/default

# Prepare folders
RUN mkdir /home/app/webapp

# Add the rails app
ADD . /home/app/webapp

WORKDIR /home/app/webapp
RUN chown -R app:app /home/app/webapp
RUN REDIS_PORT_6379_TCP_ADDR=127.0.0.1 REDIS_PORT_6379_TCP_PORT=6379 bundle install
RUN REDIS_PORT_6379_TCP_ADDR=127.0.0.1 REDIS_PORT_6379_TCP_PORT=6379 bundle exec rake assets:precompile

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
