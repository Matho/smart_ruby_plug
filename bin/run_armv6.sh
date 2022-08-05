#!/bin/bash
# If you are running on Raspbian OS, you need to change the homeuser to 'pi' or to the user you have choosen during the disk flashing
source /home/pi/.rvm/scripts/rvm

cd /home/pi/smart_ruby_plug; bundle exec /home/pi/smart_ruby_plug/bin/smart_ruby_plug start