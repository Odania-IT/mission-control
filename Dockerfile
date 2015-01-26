FROM phusion/baseimage:latest
MAINTAINER Mike Petersen <mike@odania-it.de>

ENV HOME /root
ENV TORQUEBOX_VERSION 3.1.1
ENV TORQUEBOX_HOME /opt/torquebox
ENV JBOSS_HOME $TORQUEBOX_HOME/jboss
ENV PATH $PATH:/opt/torquebox/jruby/bin


RUN apt-get update
RUN apt-get install -y openjdk-7-jdk bsdtar curl

# Add the TorqueBox distribution to /opt
WORKDIR /opt
RUN curl -L http://torquebox.org/release/org/torquebox/torquebox-dist/$TORQUEBOX_VERSION/torquebox-dist-$TORQUEBOX_VERSION-bin.zip | bsdtar -xf - && mv torquebox-$TORQUEBOX_VERSION torquebox && chmod +x torquebox/jboss/bin/*.sh

# Expose the ports we're interested in
EXPOSE 8080

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Disable ssh
RUN touch /etc/service/sshd/down

# Fix executable ruby
RUN chmod +x /opt/torquebox/jruby/bin/*

# Prepare folders
RUN mkdir -p /srv

## Create a user for the web app.
RUN addgroup --gid 9999 app
RUN adduser --uid 9999 --gid 9999 --disabled-password --gecos "Application" app
RUN usermod -L app
RUN mkdir -p /home/app/.ssh
RUN chmod 700 /home/app/.ssh
RUN chown app:app /home/app/.ssh

# Add the rails app
ADD . /srv
RUN chown -R app:app /srv

## Install Nginx runit service.
RUN mkdir /etc/service/torquebox
ADD /docker/runit/torquebox /etc/service/torquebox/run

# Create archive
WORKDIR /srv
RUN jruby -S bundle install
#RUN jruby -S bundle exec rake assets:precompile
#RUN jruby -S bundle exec rake torquebox:deploy

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
