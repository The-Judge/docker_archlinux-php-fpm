FROM derjudge/archlinux
MAINTAINER Marc Richter <mail@marc-richter.info>

# Update pacman database and fix possibly incorrect pacman db format after world upgrade
RUN pacman -Syy \
  && pacman-db-upgrade

# Install additional packages
RUN yes | pacman -S git php php-apcu php-fpm php-gd php-mcrypt php-pear postfix wget
# base-devel
RUN echo "" > /tmp/input && echo "Y" >> /tmp/input \
  && pacman -S base-devel < /tmp/input \
  && rm -f /tmp/input
# php-xhprof
RUN curl -Ls "https://aur.archlinux.org/packages/ph/php-xhprof/php-xhprof.tar.gz" \
  | tar -xz --directory /usr/src \
  && chown nobody -R /usr/src/php-xhprof \
  && cd /usr/src/php-xhprof \
  && su -c "makepkg -m" -s /bin/bash nobody \
  && yes | pacman -U php-xhprof-*.pkg.tar.xz \
  && cd \
  && rm -rf /usr/src/php-xhprof
# graphviz
RUN echo "" > /tmp/input && echo "Y" >> /tmp/input \
  && pacman -S graphviz < /tmp/input \
  && rm -f /tmp/input

# Remove orphaned packages
ADD helpers/remove_orphaned_packages.sh /tmp/
RUN chmod +x /tmp/remove_orphaned_packages.sh \
  && /tmp/remove_orphaned_packages.sh \
  && rm -f /tmp/remove_orphaned_packages.sh

# Clear pacman caches
RUN yes | pacman -Scc

# Optimize pacman database
RUN pacman-optimize

# Modify php.ini
# Remove open_basedir
RUN sed -i'' 's#^\(open_basedir.*$\)#;\1#g' /etc/php/php.ini

# Use TCP socket for php-fpm instead of file socket
RUN sed -i'' 's#^listen =.*#listen = 9000#g' /etc/php/php-fpm.conf

ADD helpers/init /
RUN chmod +x /init

EXPOSE 9000

CMD ["/init"]
