FROM alpine:3.5

ENV TIMEZONE            Europe/Warsaw
ENV PHP_MEMORY_LIMIT    512M
ENV MAX_UPLOAD          50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST        100M
ENV SHORT_OPEN_TAG	Off


RUN	apk update && \
	apk upgrade && \
	addgroup -g 82 -S www-data  && \
        adduser -u 82 -D -S -G www-data www-data && \	
	apk add --update \
		php5-mcrypt \
		php5-soap \
		php5-openssl \
		php5-gmp \
		php5-json \
		php5-zlib \
		php5-dom \
		php5-pdo \
		php5-zip \
		php5-mysql \
		php5-sqlite3 \
		php5-apcu \
		php5-pdo_pgsql \
		php5-bcmath \
		php5-gd \
		php5-xcache \
		php5-odbc \
		php5-pdo_mysql \
		php5-pdo_sqlite \
		php5-gettext \
		php5-xmlreader \
		php5-xmlrpc \
		php5-bz2 \
		php5-memcache \
		php5-iconv \
		php5-curl \
		php5-ctype \
		php5-intl \
		php5-fpm && \


sed -i "s|;*daemonize\s*=\s*yes|daemonize = no|g" /etc/php5/php-fpm.conf && \
sed -i "s|;*listen\s*=\s*127.0.0.1:9000|listen = 9000|g" /etc/php5/php-fpm.conf && \
sed -i "s|;*listen\s*=\s*/||g" /etc/php5/php-fpm.conf && \
sed -i "s/;listen.owner = nobody/listen.owner = www-data/g" /etc/php5/php-fpm.conf && \
sed -i "s/;listen.group = nobody/listen.group = www-data/g" /etc/php5/php-fpm.conf && \
sed -i "s/user = nobody/user = www-data/g" /etc/php5/php-fpm.conf  && \
sed -i "s/group = nobody/group = www-data/g" /etc/php5/php-fpm.conf && \
sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php5/php.ini && \
sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php5/php.ini && \
sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|i" /etc/php5/php.ini && \
sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php5/php.ini && \
sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php5/php.ini && \
sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= 0|i" /etc/php5/php.ini && \
sed -i "s|;*short_open_tag =.*|short_open_tag = ${SHORT_OPEN_TAG}|i" /etc/php5/php.ini && \ 

# Cleaning up
mkdir /usr/share/nginx && \
mkdir /usr/share/nginx/html && \
rm -rf /var/cache/apk/* && \
rm -rf /tmp/* && \
rm -rf /src  && \
rm -rf /var/cache/apk/*

# Set Workdir
WORKDIR /usr/share/nginx/html

# Expose volumes
VOLUME ["/usr/share/nginx/html"]

# Expose ports
EXPOSE 9000

# Entry point
ENTRYPOINT ["/usr/bin/php-fpm"]
