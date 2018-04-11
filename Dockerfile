FROM php:7.1-apache

RUN apt-get -yqq update && apt-get -yqq upgrade && apt-get install -yqq wget gnupg

RUN a2enmod rewrite

RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list \
    && curl https://download.newrelic.com/548C16BF.gpg | apt-key add - \
    && apt-get update \
    && echo newrelic-php5 newrelic-php5/application-name string "PHP Application" | debconf-set-selections \
    && echo newrelic-php5 newrelic-php5/license-key string "REPLACE_WITH_REAL_KEY" | debconf-set-selections \
    && apt-get --no-install-recommends install -yqq \
        libxrender1 \
        libxrender-dev \
        libfontconfig1 \
        libfontconfig1-dbg \
        libfontconfig1-dev \
        libxext-dev \
        libxext6 \
        libxext6-dbg \
        libxml2-dev \
        ghostscript \
        newrelic-php5-common=7.3.1.197 \
        newrelic-daemon=7.3.1.197 \
        newrelic-php5=7.3.1.197 \
    && newrelic-install install

# Install wkhtmltopf
RUN mkdir /opt/wkhtmltopdf
WORKDIR /opt/wkhtmltopdf
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
RUN tar xvfJ wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
RUN ln -s /opt/wkhtmltopdf/wkhtmltox/bin/wkhtmltopdf /usr/bin/wkhtmltopdf
RUN ln -s /opt/wkhtmltopdf/wkhtmltox/bin/wkhtmltoimage /usr/bin/wkhtmltoimage
RUN rm wkhtmltox-0.12.4_linux-generic-amd64.tar.xz

RUN apt-get clean

COPY ./infrastructure/virtualhost/apache/vhost.conf /etc/apache2/sites-available/000-default.conf

# Install PHP Extensions
RUN docker-php-ext-install opcache soap

WORKDIR /var/www/html

COPY . /var/www/html
