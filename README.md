# SmartRubyPlug

How to reduce monthly costs of your Starlink Internet connection? How to reduce the energy bill? 

## The motivation behind this project
Imagine the following situation:
- you have bought Internet connection from Starlink for your weekend house
- because it is quite expensive, you are sharing Internet connectivity via wifi with your neighbor, to cut the connectivity costs for you
- you and your neighbor do not need the connectivity each day, but mostly during weekends only
- the problem is, that Starlink is hungry for energy
- via circular 1st generation dish in standby mode it takes about 40-50W and under the load about 60-70W
- that produce high energy bill in case of 24/7 availability, more then 100 EUR / year

So, what we can do with the problem? Simply turn off the Internet connection for the time, when we do not use it and turn it on based on demand.
It can cut your energy bill dramatically!

## Explaining the idea
The idea is, that you will provide Raspberry Pi with LCD display to your neighbor and he will have option to turn your Starlink dish on, for case it is off (it is scheduled for turning off at midnight for each night)

The hardware you need to buy:
- you have to buy 2x Raspberry Pi (it doesnt matter which one exactly, I have bought one old Raspberry PI 2B and one Raspberry PI 4B via bazaar)
- the first one will be used as remote control and the second one as master node with `Home Assistant` Smart Home software
- then I have bought `Waveshare 1,3" IPS LCD display HAT 240×240` for the RPI used to act as remote device
- you need also some MicroSD card, at least 32GB
- power adapter (micro USB or USB-C based on version of RPI you have bought)
- and the most important is compatible Smart Plug with Home Assistant software. I have bought `TP-LINK Wi-Fi Smart Plug HS100`, but it is end-of-life product, so 
you will need to find some another compatible device. Try TP-LINK.

The process is following:
- you will install the Home Assistant software on master RPI node 
- then you will be able to turn on/off your Smart Plug, where the Starlink router with dish are plugged in 
- you can activate/deactivate it via the mobile app from `TP-Link`, or via `Home Assistant` software or via REST Api exposed by `Home Assistant`
- under the hood, this project is using the REST API for communication with the Smart Plug
- you will provider the second Raspberry PI to your neighbor and it will act as remote control to activate on your Starlink satellite (turn on the Smart Plug)
- I expect, you have connected houses via WiFi antennas (or via ethernet cable), so both RPIs can communicate in the same network between your houses
- the end user can control the RPI via small LCD display, where 3 buttons are present
- the first button will have functionality to turn the Smart Plug on
- the second button will switch the display to screen with more details and less details (so called "status page" about nodes in the network)
- for example status about your both Wifi antennas, and status of the Internet connectivity (availability for ping response)
- there is another Python repository, also developed by me, which aim is to render the screens on the small LCD display
- it is written in Python because of LCD driver support
- this Ruby project communicates via that Python project via command line, in the background (running on Ubuntu)
- end user can switch between the main screen and screen with more details 
- the last task is to install the Ubuntu OS on the remote control RPIs and install this Ruby and Python projects there
- test it

Note: I'm not going to prepare functionality to turn the Internet off via remote device. (at least not in this MVP) It could produce issues, when you both are connected to the Internet.
So idea is, that the Smart Plug with Starlink dish will turn off by schedule each night at midnight. And you will turn on the Internet only on demand. 

I believe, you will save a lot of money each year!

## Installation

## Running tests


## TODOs
- tag and push to RubyGems, once ready to test
- docker repository with pre-installed projects
- rubocop validation
