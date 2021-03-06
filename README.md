# About this Image #

This image is based on [my minimal Arch Linux image](https://registry.hub.docker.com/u/derjudge/archlinux/), based upon
the [official Arch Linux base image](https://registry.hub.docker.com/u/base/archlinux/).
It provides everything necessary to provide a PHP-FPM server. It is aimed to be used together with other containers,
which serve a webserver, like nginx or apache.

# What's provided? #

Aside from what is included in the [official Arch Linux base image](https://registry.hub.docker.com/u/base/archlinux/),
the following additional packages are included:

* Git
* PHP
    * apcu
    * fpm
    * gd
    * mcrypt
    * pear
    * xhprof
* Postfix

# How to set individual PHP settings? #

You can override the defaults in /etc/php/php.ini by starting your container with ``-v YOUR_HOSTDIR:/etc/php_custom``
and save one or more files ending on ``.ini`` to that directory. On startup, a symlink will be created for every such
file in ``/etc/php/conf.d`` and used by PHP-FPM.
