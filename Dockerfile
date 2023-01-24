FROM moodlehq/moodle-php:7.4

# Add Moodle code
ADD https://github.com/moodle/moodle/archive/MOODLE_<version>.zip /var/www/html/
RUN unzip /var/www/html/MOODLE_<version>.zip -d /var/www/html/ && \
    mv /var/www/html/moodle-MOODLE_<version>/* /var/www/html/ && \
    rmdir /var/www/html/moodle-MOODLE_<version>

# Configure Apache
COPY moodle.conf /etc/apache2/sites-available/
RUN a2dissite 000-default.conf && \
    a2ensite moodle.conf && \
    a2enmod rewrite

# Run Moodle installation script
RUN chown -R www-data:www-data /var/www/html/config.php
COPY install.php /var/www/html/

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
