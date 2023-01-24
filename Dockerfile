FROM registry.access.redhat.com/ubi8/php-74

# Install necessary packages
RUN yum update -y && \
    yum install -y \
        icu \
        mariadb-devel \
        postgresql-devel \
        libxml2-devel \
        unzip

# Configure PHP extensions
RUN php -m | grep -q intl || \
    echo "installing intl extension" && \
    yum install -y php-intl

RUN yum install -y php-pdo_mysql php-pgsql php-soap

# Add Moodle code
RUN rm -rf /var/www/html/*
ADD https://github.com/moodle/moodle/archive/MOODLE_<version>.zip /var/www/html/
RUN unzip /var/www/html/MOODLE_<version>.zip -d /var/www/html/ && \
    mv /var/www/html/moodle-MOODLE_<version>/* /var/www/html/ && \
    rmdir /var/www/html/moodle-MOODLE_<version>

# Configure Apache
COPY moodle.conf /etc/httpd/conf.d/

# Run Moodle installation script
RUN chown -R apache:apache /var/www/html/config.php
COPY install.php /var/www/html/

CMD ["httpd", "-D", "FOREGROUND"]
