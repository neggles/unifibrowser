# grab composer
FROM composer AS composer
ARG APP_REPO="https://github.com/Art-of-WiFi/UniFi-API-browser.git"
ARG APP_TAG="v2.0.22"

# clone the repo
WORKDIR /app
RUN git clone --single-branch --branch=$APP_TAG --depth=1 $APP_REPO .

# run composer install to install the dependencies
RUN composer install \
  --optimize-autoloader \
  --no-interaction \
  --no-progress

# continue stage build with the desired image and copy the source including the
# dependencies downloaded by composer
FROM trafex/php-nginx AS unifibrowser
COPY --chown=nginx --from=composer /app /var/www/html
COPY --chown=nginx config/app/*.php /var/www/html/config/
#COPY --chown=nginx config/php-fpm.ini /etc/php8/conf.d/settings.ini

ENV UNIFI_NAME="Default"
ENV UNIFI_HOST="unifi"
ENV UNIFI_PORT="443"
ENV UNIFI_USER="ubnt"
ENV UNIFI_PASS="ubnt"

ENV APP_AUTH="true"
ENV APP_USER="admin"
ENV APP_PASS="admin"
ENV APP_THEME="bootstrap"
ENV APP_NB_CLASS="dark"
ENV APP_NB_COLOR="dark"
