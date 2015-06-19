FROM derjudge/archlinux
MAINTAINER Marc Richter <mail@marc-richter.info>

# Update pacman database and fix possibly incorrect pacman db format after world upgrade
RUN pacman -Syy \
  && pacman-db-upgrade

# Remove orphaned packages
ADD helpers/remove_orphaned_packages.sh /tmp/
RUN chmod +x /tmp/remove_orphaned_packages.sh \
  && /tmp/remove_orphaned_packages.sh \
  && rm -f /tmp/remove_orphaned_packages.sh

# Install additional packages
RUN yes | pacman -S git php php-apcu php-fpm php-gd php-mcrypt php-pear php-xhprof postfix

# Clear pacman caches
RUN pacman -Scc

# Optimize pacman database
RUN pacman-optimize
