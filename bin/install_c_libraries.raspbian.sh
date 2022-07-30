#!/bin/bash

cd /home/pi
wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.68.tar.gz
tar zxvf bcm2835-1.68.tar.gz
cd bcm2835-1.68/
./configure && make && make check && make install

cd /home/pi
git clone https://github.com/WiringPi/WiringPi
cd WiringPi
./build
gpio -v