FROM debian:stretch

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	php7.0-fpm php7.0-cli php7.0-mysqlnd php7.0-pgsql php7.0-sqlite3 php7.0-redis \
	php7.0-apcu php7.0-intl php7.0-imagick php7.0-mcrypt php7.0-json php7.0-gd php7.0-curl \
	mcrypt apache2 libapache2-mod-php7.0 libapache2-mod-auth-mellon \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get -y autoclean

RUN a2enmod proxy && \
	a2enmod proxy_http && \
	a2enmod ssl && \
	a2enmod dav_fs && \
	a2enmod rewrite && \
	a2enmod ldap authnz_ldap && \
	service apache2 stop

RUN echo "ServerName apache.docker.yanniks.one" | tee /etc/apache2/conf-available/fqdn.conf && a2enconf fqdn
COPY apache2-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/apache2-foreground

EXPOSE 80

CMD ["apache2-foreground"]
