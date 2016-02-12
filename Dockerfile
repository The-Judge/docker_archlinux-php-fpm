FROM derjudge/archlinux
MAINTAINER Marc Richter <mail@marc-richter.info>

# Update pacman database and fix possibly incorrect pacman db format after world upgrade
RUN yes | pacman -Suyy \
  && pacman-db-upgrade

# Install additional packages
RUN yes | pacman -S git openssh php php-apcu php-apcu-bc php-fpm php-gd php-mcrypt postfix wget
# base-devel
RUN echo "" > /tmp/input && echo "Y" >> /tmp/input \
  && pacman -S base-devel < /tmp/input \
  && rm -f /tmp/input
## php-xhprof
#RUN git clone https://aur.archlinux.org/php-xhprof.git /usr/src/php-xhprof \
#  && chown nobody -R /usr/src/php-xhprof \
#  && cd /usr/src/php-xhprof \
#  && su -c "makepkg -m" -s /bin/bash nobody \
#  && yes | pacman -U php-xhprof-*.pkg.tar.xz \
#  && cd \
#  && rm -rf /usr/src/php-xhprof
# graphviz
RUN echo "" > /tmp/input && echo "Y" >> /tmp/input \
  && pacman -S graphviz < /tmp/input \
  && rm -f /tmp/input

## Remove orphaned packages
#ADD helpers/remove_orphaned_packages.sh /tmp/
#RUN chmod +x /tmp/remove_orphaned_packages.sh \
#  && /tmp/remove_orphaned_packages.sh \
#  && rm -f /tmp/remove_orphaned_packages.sh

# Clear pacman caches
RUN yes | pacman -Scc

## Fix for missing GPG keys
#RUN rm -R /etc/pacman.d/gnupg \
#  && pacman-key --init \
#  && pacman -Syy \
#  && pacman-key --populate archlinux

# Optimize pacman database
RUN pacman-optimize

# Modify php.ini
# Remove open_basedir
RUN sed -i'' 's#^\(open_basedir.*$\)#;\1#g' /etc/php/php.ini

# Use TCP socket for php-fpm instead of file socket
RUN sed -i'' 's#^listen =.*#listen = 9000#g' /etc/php/php-fpm.conf
# Include /etc/php/fpm.d/*.conf for php-fpm
RUN sed -i'' 's#^;\(include=\/etc\/php\/fpm\.d\/\*\.conf.*$\)#\1#g' /etc/php/php-fpm.conf

ADD helpers/init /
RUN chmod +x /init

# Copy php-fpm templates to image
ADD templates /templates/

EXPOSE 9000

CMD ["/init"]
