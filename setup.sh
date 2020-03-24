#!/bin/bash

sudo su
cd /usr/lib/chromium-browser
wget http://blog.vpetkov.net/wp-content/uploads/2019/09/libwidevinecdm.so_.zip
unzip libwidevinecdm.so_.zip && chmod 755 libwidevinecdm.so
wget http://blog.vpetkov.net/wp-content/uploads/2020/03/chromeos-browser.desktop.zip
unzip chromeos-browser.desktop.zip && mv chromeos-browser.desktop /usr/share/applications
