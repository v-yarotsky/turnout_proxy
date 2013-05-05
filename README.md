Turnout Proxy
=============

[![Gem Version](https://badge.fury.io/rb/turnout_proxy.png)](http://badge.fury.io/rb/turnout_proxy)

Proxy server which allows to switch between two destination servers using a lock file.

There is an example init.d script in [scripts/init.d/turnout.example](https://github.com/v-yarotsky/turnout_proxy/blob/master/scripts/init.d/turnout.example)
- adjust it to your needs

Also there is an example Apache httpd config snippet in [scripts/httpd/conf.d/turnout_proxy.example.conf](https://github.com/v-yarotsky/turnout_proxy/blob/master/scripts/httpd/conf.d/turnout_proxy.example.conf)
- adjust to your needs. *WARNING* this config is insecure!

Installation:
-------------

    $ gem install turnout_proxy

Usage:
------

    $ turnout_proxy --help

