FROM ubuntu:latest
# Install Nginx and ISC BIND
RUN \
  apt-get update \
  && apt-get install -y software-properties-common \
  && add-apt-repository -y ppa:nginx/stable \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq nginx bind9 bind9-host dnsutils vim \
  && rm -rf /var/lib/apt/lists/*
# Copy the base config files
COPY files/named.conf /etc/named.conf
COPY files/nginx.conf /etc/nginx/nginx.conf
# and my startup script.
COPY files/entrypoint.sh /sbin/entrypoint.sh
# Make sure they are owned by the right users, and make my BIND dirs.
RUN \
       chown -R www-data:www-data /var/lib/nginx \
    && chmod 755 /sbin/entrypoint.sh \
    &&   mkdir -m 0775 -p /var/run/named \
    && chown root:bind /var/run/named  \
    && mkdir -m 0775 -p /var/named/data \
    && chown root:bind /var/named
# Expose ports.
EXPOSE 853 443
# Define working directory.
WORKDIR /etc/nginx
CMD ["/sbin/entrypoint.sh"]
