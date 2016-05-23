FROM jkirkby91/ubuntusrvbase:latest
MAINTAINER James Kirkby <james.kirkby@sonyatv.com>

# Install packages specific to our project
RUN apt-get update && \
apt-get upgrade -y && \
apt-get install php5-fpm php5-cli php5-mysql php5-curl php5-gd php5-intl php5-mcrypt php5-tidy php5-xmlrpc php5-xsl php5-xdebug php5-memcached php-pear nodejs -y --force-yes --fix-missing && \
apt-get remove --purge -y software-properties-common build-essential && \
apt-get autoremove -y && \
apt-get clean && \
apt-get autoclean && \
echo -n > /var/lib/apt/extended_states && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /usr/share/man/?? && \
rm -rf /usr/share/man/??_*

# Install composer
RUN sed -i -e "s/;cgi.fix_pathinfo=0/cgi.fix_pathinfo=1/g" /etc/php5/fpm/php.ini && \
sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini && \
sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini && \
sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf && \
sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf && \
sed -i -e "s/pm.max_children = 5/pm.max_children = 9/g" /etc/php5/fpm/pool.d/www.conf && \
sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php5/fpm/pool.d/www.conf && \
sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php5/fpm/pool.d/www.conf && \
sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php5/fpm/pool.d/www.conf && \
sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php5/fpm/pool.d/www.conf && \
echo "security.limit_extensions = .php" >> /etc/php5/fpm/pool.d/www.conf

# Port to expose (default: 9000)
EXPOSE 9000

# Copy supervisor conf
COPY confs/supervisord/supervisord.conf /etc/supervisord.conf

COPY start.sh /start.sh

RUN chmod 777 /start.sh

# Set entrypoint
CMD ["/bin/bash/, "/start.sh"]
