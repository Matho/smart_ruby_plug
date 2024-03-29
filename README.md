# Smart Ruby Plug

Do you want to reduce monthly energy costs of your Starlink Internet connection? 

The project has 3 repositories
- [Matho/smart_ruby_plug](https://github.com/Matho/smart_ruby_plug) - this is main Ruby project
- [Matho/smart_ruby_plug_c](https://github.com/Matho/smart_ruby_plug_c) - C source code for those, who want to change the drawing on the Raspberry Pi display
- [Matho/smart_ruby_plug_c_binaries](https://github.com/Matho/smart_ruby_plug_c_binaries) - prebuilded C binaries (.so file) for those, who do not want to build the binary from source code

You can find the **demo video** at [this link](http://websupport.matho.sk/smart_plug.webm)  
See [wiki](https://github.com/Matho/smart_ruby_plug/wiki/End-User-manual) for end-user manual.

## 1. The motivation behind this project
Imagine the following situation:
- you have bought Internet connection from Starlink for your weekend house
- because it is quite expensive, you are sharing Internet connectivity via wifi with your neighbor, to cut the connectivity costs for you
- you and your neighbor do not need the connectivity each day 24/7, but mostly during weekends only
- the problem is, that Starlink is hungry for energy
- via circular 1st generation dish in standby mode it takes about 40-50W and under the load about 60-70W.
- when snow melting mode is active, it can probably reach 100W
- that produce high energy bill in case of 24/7 availability, more then 100 EUR / year

So, what we can do with the problem? Simply turn off the Internet connection for the time, when we do not use it and turn it on based on demand.
It can cut your energy bill dramatically!

### 1.1 Explaining the idea
The idea is, that you will provide Raspberry Pi with LCD display to your neighbor and he will have option to turn your Starlink dish on, for case it is off (it is scheduled for turning off at midnight for each night)

The hardware you need to buy:
- you have to buy 2x Raspberry Pi. You need min 1GB ram model for Home Assistant node and min512MB ram model for the remote device. 
- the project works both on armv7l and aarch64
- the first one will be used as remote control and the second one as master node with `Home Assistant` smart home software
- then I have bought [Waveshare 1,3" IPS LCD display HAT 240×240](https://www.waveshare.com/1.3inch-lcd-hat.htm) for the RPI used to act as remote device
- you need also some 2x MicroSD card, 32GB should be good enough
- 2x power adapter
- and the most important is compatible Smart Plug with Home Assistant software. I have bought [TP-LINK Wi-Fi Smart Plug HS100](https://www.tp-link.com/cz/home-networking/smart-plug/hs100/), but it is end-of-life product, so 
you will need to find some another compatible device. Try TP-LINK and check for compatibility with Home Assistant at [https://www.home-assistant.io/integrations/tplink/](https://www.home-assistant.io/integrations/tplink/)

### 1.2 The process is following:
- you will install the [Home Assistant](https://www.home-assistant.io/installation/raspberrypi/) software on master RPI node 
- then you will be able to turn on/off your Smart Plug, where the Starlink router with dish are plugged in 
- you can activate/deactivate it via the mobile app from `TP-Link`, or via `Home Assistant` software or via REST Api exposed by `Home Assistant`
- under the hood, this project is using the REST API for communication with the Smart Plug
- you will provide the second Raspberry PI to your neighbor and it will act as remote control to activate on your Starlink satellite (turn on the Smart Plug)
- I expect, you have connected houses via WiFi antennas (or via ethernet cable), so both RPIs can communicate in the same network between your houses
- the end user can control the RPI via small LCD display (by pressing any button)
- when button is pressed, it will show booting screen
- when booted, it will switch between on/off/error screens
- on error screen, the diagnostic info about which node in the network is off are shown
- this Ruby project is communicating via prebuilded `.so` file in the C-project repository
- the display drawing and check for key press is written in this associated C project
- you need to install the Ubuntu OS on the remote control RPIs and install this Ruby projects there
- test it

Note: I'm not going to prepare functionality to turn the Internet off via remote device. (at least not in this MVP) It could produce issues, when you both are connected to the Internet.
So idea is, that the Smart Plug with Starlink dish will turn off by schedule each night at midnight. And you will turn on the Internet only on demand. 

### 1.3 The costs:
I have identified following costs: 

- display ... 16 EUR
- smart plug ... 38 EUR
- 1x Raspberry Pi 1GB model ... 45 EUR
- 1x Raspbery Pi Zero 2W with GPIO header .... 23 EUR 
- 2x power adapter .. 2x10EUR
- 2x ethernet cable ... 2x1.5EUR
- 2x micro SD card ... 2x8EUR
- 2x some rpi case ... optional
- shipping for orders from eshops ... unknown/optional

Total*: 151 EUR

**Note:** The yearly energy bill is expected at `430Kwh` It should cost about 100 EUR / year. 
I expect you can sell the used items on bazaar after few years with 70% of buy price,
so **your initial costs in this case would be only 46 EUR.** Also, you need to include here the saved energy costs.

**Note 2:** Raspbery Pi Zero 2W was not tested by me. But based on the its parameters, it should work too. The memory consumption on the node with Home Assistant is about 500MB. Not sure, but maybe it would work on RPI ZERO 2W also for the master node.

**Note 3:** Currently there is big issue with Raspberry Pi availability. The costs on Ebay are sometimes more then twice the price I'm including on this purchase list.

**Note 4:** I recommend some kind of battery like PiJuice HAT to do soft shutdown of operating system.  

## 2 Demo video
You can find the demo video at [this link](http://websupport.matho.sk/smart_plug.webm) 

**Note:** There is big pause between rendering the screens. This delay is customizable via settings.

## 3. Installation

### 3.1 Home Assistant installation
Currently (17.7.2022) the Home Assistant software supports Python v3.9+. Because I was running my existing rpi based on Ubuntu 20.04, I needed 
to upgrade system to 22.04 and to upgrade Python to v3.10 package.

I have done steps written in this article [https://www.techrepublic.com/article/how-to-upgrade-ubuntu-server-from-20-04-to-22-04/](https://www.techrepublic.com/article/how-to-upgrade-ubuntu-server-from-20-04-to-22-04/)

Once your Ubuntu is upgraded to 22.04 we can continue with Home Assistant installation.
At first, ensure, you have Docker and Docker-compose already installed. The tutorial how to install 
Home Assistant via Docker is at [https://www.home-assistant.io/installation/raspberrypi/#install-home-assistant-container](https://www.home-assistant.io/installation/raspberrypi/#install-home-assistant-container)

`mkdir ~/HA`  
`cd ~/HA`

`vim docker-compose-ha.yml`

Include following: 
```
version: '3'
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - /home/ubuntu/HA:/config
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped
    privileged: true
    network_mode: host
```
Start the docker-compose via:  
`sudo docker-compose -f docker-compose-ha.yml up -d`

Restart OS, does it starts after reboot? Navigate in browser to `http://<host>:8123` If you are
using firewall , open 8123 port via `ufw`

We will use wifi-based smart plug, so we do not need to install any Z-wave or Zigbee device integrations.

Now we can continue in installation. Next step is to install [Home Assistant Core](https://www.home-assistant.io/installation/raspberrypi/#install-home-assistant-core)

Detect the Python version. It should be 3.9+ at the time of writing this tutorial. Home Assistant supports 2 latest minor Python releases, check the info of supported Python version by Home Assistant.

```
sudo apt-get update
sudo apt-get upgrade -y
```

Instal the dependencies via:
```
sudo apt-get install -y python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev libjpeg-dev zlib1g-dev autoconf build-essential libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata
```

Then create account:
`sudo useradd -rm homeassistant`

Create virtual environment:
```
sudo mkdir /srv/homeassistant
sudo chown homeassistant:homeassistant /srv/homeassistant

sudo -u homeassistant -H -s
cd /srv/homeassistant
python3 -m venv .
source bin/activate

python3 -m pip install wheel
pip3 install homeassistant

hass
```
The hass command could take up to 10 minutes.

The Home Assistant endpoint is available on the `http://your-ip-here:8123` 
If you are using firewall, open the port via `sudo ufw allow 8123`
Try reboot, if it auto starts.

#### 3.1.1 Home Assistant settings
Navigate to the profile and generate long-lived token. This token you will use when doing REST queries to Home Assistant REST Api.
Insert the token to `config/settings.yml`

### 3.2 Smart Plug installation
Install the `Tplink's` [Kasa Smart](https://play.google.com/store/apps/details?id=com.tplink.kasa_android&hl=sk&gl=US) mobile application and follow the instructions in mobile app.
After successfull pairing, add the device in Home Assistant.

To add new smart plug to Home Assistant, follow doc at [https://www.home-assistant.io/integrations/tplink/](https://www.home-assistant.io/integrations/tplink/)

If you are connecting to SSID lets say X, you need the X network be the same, like the network where your Home Assistant node is available.
If the networks do not mach (like at my situation) you will need to add port forwarding from network X to network Y.
I have tried to scan open ports on smart plug via `nmap -Pn 10.0.2.105`
The response is:
```
PORT     STATE SERVICE
9999/tcp open  abyss
```

So I need to set port forwarding from port `9999` on the router, to port `9999` on the smart plug. 
Note: The port depents on your smart plug model. If you have TPlink router, login to router IP and navigate 
advanced > nat forwarding > virtual servers. There add port forwarding for port 9999.

If the smart plug was not auto discovered by Home Assistent, do following steps: (source: [https://www.home-assistant.io/integrations/tplink/](https://www.home-assistant.io/integrations/tplink/))
- Browse to your Home Assistant instance.  
- In the sidebar click on  Settings.
- From the configuration menu select: Devices & Services.
- In the bottom right, click on the  Add Integration button.
- From the list, search and select “TP-Link Kasa Smart”.

Follow the instruction on screen to complete the set up.

In the modal, insert the IP of your router, where you have set port forwarding. Do not write the IP of the smart plug, as it is in another network and is not reachable.

You can check to turn on/off the plug via Home Assistant, or via REST API. The REST APIs doc is at [https://developers.home-assistant.io/docs/api/rest/](https://developers.home-assistant.io/docs/api/rest/)

### 3.2.1 Postman requests
Replace `10.0.3.3:8123` with the IP of Home Assistant node and 8123 with the port. If you havent changed it, the default port is `8123`

### 3.2.1.1 Turn on/off the plug
**Turn on:**  
POST url: `http://10.0.3.3:8123/api/services/switch/turn_on`

**Turn off:**  
POST url: `http://10.0.3.3:8123/api/services/switch/turn_off`

**Headers section:**  
For Bearer, set your long lived token from Home Assistant:  
```
Content-Type: application/json
Authorization: Bearer eyJ0eXA...
```

**Body:**  
- select raw
- select application/json
- Body value: (change the `smart_zasuvka_1090` to your name)
```
{
    "entity_id": "switch.smart_zasuvka_1090"
}
```

### 3.2.1.2 Get status of plug
(change the `smart_zasuvka_1090` to your name)  

GET url: `http://10.0.3.3:8123/api/states/switch.smart_zasuvka_1090`

**Headers section:**  
For Bearer, set your long lived token from Home Assistant:
```
Content-Type: application/json
Authorization: Bearer eyJ0eXA...
```



### 3.3 SmartRubyPlug installation
You need to install the Ubuntu OS to the rpi device, which will act as remote controller. Alternatively, Raspberry PI OS Lite for armv6 devices (PI Zero).

You can use Raspberry Pi's Imager to prepare bootable micro SD card. Select Ubuntu 22.04 aarch64 for Raspberry Pi 4B. 
Once the card is prepared, insert it into rpi. The default user is ubuntu and password is `ubuntu`. You will be requested to 
change the password immediately. You can set ssh keys to do not require copy paste the password for each login.

If you dont want to use ethernet port for internet, but wifi instead, I recommend to check this article [https://arstech.net/raspberry-pi-4-ubuntu-wifi/](https://arstech.net/raspberry-pi-4-ubuntu-wifi/)

**Note:** If you are running on armv6 compatible device (PI Zero, PI 1), you need to flash 32bit Raspbian (Raspberry PI OS Lite). You will select the wifi and user credentials via Imager software, in the right bottom corner - the setting icon.  

**Note 2:** If you have 512MB ram device and you want to use ram disk (read-only filesystem) in "production", do not follow the Docker part, you will do not have enough memory for Docker image. Follow non-docker instructions and compile ruby from source code (rvm installation).

**For Docker installation** see chapter `6. Dockerfile building and running via Docker` for more info. 

Now we need to install [RVM](https://rvm.io/). RVM is Ruby Version Manager and with RVM you can install multiple Ruby language versions in the same OS and switch between versions easily.

`sudo apt-get update`

Install GPG keys:  
`sudo apt install gnupg2`  
`gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB`

Install RVM:
```
curl -sSL https://get.rvm.io | bash -s stable
```
Install Vim editor
```
sudo apt-get install vim
```

Reload RVM shell for each login:
```
vim ~/.bashrc 
```
Before the last `export PATH`, write:
``` 
source ~/.rvm/scripts/rvm
```
This will activate RVM after each login.
Logout and login again.

Download this SmartRubyPlug project to the home folder, eg to `/home/ubuntu/smart_ruby_plug`. If you are running Raspberry PI OS Lite, replace `ubuntu` with `pi`. 
```
sudo apt-get install git
cd ~
git clone https://github.com/Matho/smart_ruby_plug.git
```

**Note:** it is not the best to clone master branch. Clone tag with version you want to download, instead.


Navigate to `cd ~/smart_ruby_plug`. You should be asked to switch to RVM Ruby version from project. Type `y` to yes and `enter`.
Install the Ruby version, the RVM is asking to install. (do NOT use sudo before this command)
```
rvm install "ruby-3.1.2"
```
This could take few minutes, it will compile Ruby, if no binaries are found. On Raspberry Pi ZERO it could take up to 2.5 hours, if no binaries are found. 

After Ruby is installed, you can install project dependencies.   
`gem install bundler`  
`bundle install`

Then you need to copy the prebuilded C `.so` file or compile the .so file from C-code repository. This file should be in the following project path: `lib/clibrary/libsmart_plug_C.so`


Note: Enable SPI interface
```
sudo apt-get install raspi-config
sudo raspi-config
# Choose Interfacing Options -> SPI -> Yes  to enable SPI interface
sudo reboot
```
You need to install the ping command, via:
```
sudo apt-get install iputils-ping
```

To be able build the libraries, you need to install:
```
sudo apt-get install gcc cmake
```

**Install BCM2835 libraries**

```
cd ~
wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.68.tar.gz
tar zxvf bcm2835-1.68.tar.gz 
cd bcm2835-1.68/
sudo ./configure && sudo make && sudo make check && sudo make install
#For more details, please refer to http://www.airspayce.com/mikem/bcm2835/ 
```

**Install wiringPi libraries**
```
cd ~
git clone https://github.com/WiringPi/WiringPi
cd WiringPi
./build
gpio -v
# Run gpio -v and version 2.70 or newer will appear. If it does not appear, it means that there is an installation error
```

### 3.4 C-binary installation
The display redrawing and detection for keypress is written via C code. Then, the `main.so` file is prepared and Ruby is calling the C functions via `FFI` gem.

#### 3.4.1 Using precompiled .so file
Download the C project binary repository:
```
cd ~
git clone https://github.com/Matho/smart_ruby_plug_c_binaries.git
```

You can point symlink for Ruby project to file `/home/ubuntu/smart_ruby_plug_c/main.so`. If running on Raspbian, use `pi` instead of `ubuntu`

Start the ruby app:
```
cd ~/smart_ruby_plug
bundle exec bin/smart_ruby_plug start
```

#### 3.4.2 Compilation

If you want to compile the C code instead of using the prebuilded binary, you can follow this steps.

The instructions are extracted from [https://www.waveshare.com/wiki/1.3inch_LCD_HAT](https://www.waveshare.com/wiki/1.3inch_LCD_HAT)

Because we are not using Python source code examples, we do not need to install Python. 
Also, we do not need to install FBCP driver as we are not displaying the OS GUI screens, but only drawing, like on canvas.

Download the C project repository code to 
```
cd ~
git clone https://github.com/Matho/smart_ruby_plug_c.git
```

To build the C project on rpi, you need to install following dependencies:
```
sudo apt-get install gcc doxygen cmake gdb
```

Build the project via Makefile (or via Clion IDE, if you have configured it correctly):
```
cd ~/smart_ruby_plug_c
mkdir bin
# make clean will show error for the first time
make clean
make
```
You should see new `main.so` file. You can prepare symlink for Ruby project:
```
ln -s ~/smart_ruby_plug_c/main.so ~/smart_ruby_plug/lib/clibrary/libsmart_plug_C.so 
```

If you are going to do more work with this C project, you can setup `Clion IDE` settings to synchronize target files with your local files in IDE and run 
the building on rpi. The building works only on compatible raspberry pi, it will fail on your localhost. The instruction can be found on [https://www.jetbrains.com/help/clion/remote-projects-support.html](https://www.jetbrains.com/help/clion/remote-projects-support.html)

Start the ruby app:
```
cd ~/smart_ruby_plug
bundle exec bin/smart_ruby_plug start
```

#### 3.4.4 Using custom fonts:
Only few fonts and font sizes are available currently. If you want to change the font sizes to your custom, you will need to run this project [https://github.com/zst-embedded/STM32-LCD_Font_Generator](https://github.com/zst-embedded/STM32-LCD_Font_Generator)
It needs python v3.6. To do not break your current Ubuntu system on your localhost, I recommend to start up new VM for example in `DigitalOcean`.
If you want to install Python 3.6 on Ubuntu 22.04, you can follow this tutorial [https://stackoverflow.com/questions/72102435/how-to-install-python3-6-on-ubuntu-22-04](https://stackoverflow.com/questions/72102435/how-to-install-python3-6-on-ubuntu-22-04)

Then:
```
sudo apt install python3-pip

cd STM32-LCD_Font_Generator
python3.6 -m pip install regex

sudo apt-get install libjpeg-dev
python3.6 -m  pip install Pillow

wget https://github.com/nascarsayan/fonts-1/raw/master/Menlo.ttc
// use the custom font size in argument
python3.6 ../stm32-font.py --font Menlo.ttc --size 42
```
Rewrite the generated file based on the existing C files in project

### 3.5 Start the app on reboot
Currently, the app is not started on reboot. To do, follow this commands:
(note: more info about service restarting can be found at [https://ma.ttias.be/auto-restart-crashed-service-systemd/](https://ma.ttias.be/auto-restart-crashed-service-systemd/))

Create new file:
``` 
sudo vim /etc/systemd/system/smart_ruby_plug.service
```

and insert there: (change `ubuntu` to `pi` for Raspberry PI Os) and `run_armv6.sh` for Raspbery PI OS.
```
[Unit]
After=

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
Restart=on-failure
RestartSec=5s

ExecStart=/home/ubuntu/smart_ruby_plug/bin/run.sh

[Install]
WantedBy=default.target
```

Apply changes:
```
sudo systemctl daemon-reload
sudo systemctl start smart_ruby_plug.service
```

And auto start on reboot:
``` 
sudo systemctl enable smart_ruby_plug.service
```

Check the status via:
```
sudo systemctl status smart_ruby_plug.service
```

## 4 Start the app manually (without systemctl)
Build the `.so` binary on your Raspberry Pi. Then copy the builded file to the `lib/clibrary/libsmart_plug_C.so`

Navigate to the root folder of this app and run:  
`bundle exec bin/smart_ruby_plug start`

**Note:** You need to push the button for 2 seconds. Only the light click for few miliseconds doesnt register the key press event.

## 5. Running tests
Log in to your raspberry pi, `cd` to the project and run:
`rspec .`

The project need the prebuilded `.so` file. 

### 5.1 Running rspec on amd64 machine
Alternatively, you can use prebuilded `libsmart_plug_C.so.for_tests` located in `lib/clibrary`. This is "empty" clibrary file, so it is able to run 
it also on amd64 machine, without needed C packages. You can rename it to `libsmart_plug_C.so` and start the tests on  your localhost (not from rpi).

## 6. Dockerfile building and running via Docker

Note: Enable SPI interface
```
sudo apt-get install raspi-config
sudo raspi-config
# Choose Interfacing Options -> SPI -> Yes  to enable SPI interface
sudo reboot
```

### 6.1.1 Install Docker on RPI 2+
```
sudo apt-get install \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common
```

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
Use proper architecture - `arm64` for >= Raspberry Pi 3B or `armhf` for <= Raspberry Pi 2B
```
sudo add-apt-repository \
"deb [arch=arm64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
```

```
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose


sudo docker run hello-world
```

### 6.1.2 Install Docker on Rpi 1/ZERO (and armv6 devices)
Follow this steps [https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script](https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script)

```
curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh
```

Then, we need to install docker-compose.
```
sudo apt-get install docker-compose
```
Note: This installation removes docker and install older version. Not sure, why it happens, but docker-compose works.

Start the Docker service:  
```
sudo systemctl start docker.service
```

### 6.2 Build this image
If you want to only run the image with last version, skip to docker-compose tutorial in next section.

```
git clone https://github.com/Matho/smart_ruby_plug.git
```
`cd ~/docker-builds/smart_ruby_plug`  

Pass `--no-cache` for clean build and pass correct url with C binary version for C_BINARY_PATH arg.

For aarch64:  
`sudo docker build -t mathosk/smart_ruby_plug:v0.3.0_aarch64 --build-arg ARCH=aarch64 --build-arg C_BINARY_PATH=https://github.com/Matho/smart_ruby_plug_c_binaries/releases/download/v0.1.0.beta/libsmart_plug_C.so.v0.1.0.beta_77865ad7af .`

Alternatively for armv7l:  
`sudo docker build -t mathosk/smart_ruby_plug:v0.3.0_armv7l --build-arg ARCH=armv7l --build-arg C_BINARY_PATH=https://github.com/Matho/smart_ruby_plug_c_binaries/raw/master/armv7l_32/v0.1.0/libsmart_plug_C.so.v0.1.0.beta_77865ad7af .`

For armv6:  
`sudo docker build -t mathosk/smart_ruby_plug:v0.3.0_armv6 --file Dockerfile.raspbian --build-arg C_BINARY_PATH=https://github.com/Matho/smart_ruby_plug_c_binaries/raw/master/armv6/v0.1.0/libsmart_plug_C.so.v0.1.0.beta_77865ad7af .`
**Note:** If you have selected different user for Raspbian OS from `pi`, you need to change it in the `Dockerfile.raspbian` file to point to the correct path

### 6.3 Execute
`-d` means detached - running in background. If you do not want to run it in background (for test purposes) remove `-d` option from command line

```
sudo docker run --privileged -d mathosk/smart_ruby_plug:v0.2.0 
```

**Note:** amd64 arch is not prebuilded, as you need to run this sw on the Raspberry Pi. 

#### 6.3.1 Docker Compose
You need to have installed the `docker-compose` package. Check it via:
`docker-compose --version`

Copy `smart_ruby_plug/config/settings.yml` file with modified yml according your needs and upload it to folder
`/data/smart_ruby_plug/config` on your Raspberry Pi. 

The docker-compose file is located in this project root. Please, before you start it, point to correct version you want to pull (inside docker compose yml) and specify correct arch in the filename call.

You can start the project via: (use `-d` for run in background)  
```
sudo docker-compose -f docker-compose_aarch64.yml up -d
```

You can stop it via:  
```
sudo docker-compose -f docker-compose_aarch64.yml down
```

#### 6.3.2 Ram usage
I have installed Ubuntu 22.04 32bit edition on Raspberry Pi 2B model . This model has 1GB ram.
In standby mode, without this application, it takes 180MB ram. With this app it is almost 200MB ram usage.

### 7 Read-only filesystem (ram disk) instead of batteries
Stop the systemctl service for this app, before you are going to setup readonly filesystem:  
```
sudo systemctl stop smart_ruby_plug.service
```

You can run on PiJuice HAT / PiSugar batteries. But better way is to run on read-only filesystem. I have chosen this way.
The good articles are at [https://medium.com/swlh/make-your-raspberry-pi-file-system-read-only-raspbian-buster-c558694de79](https://medium.com/swlh/make-your-raspberry-pi-file-system-read-only-raspbian-buster-c558694de79) and [https://grafolean.medium.com/run-docker-on-your-raspberry-pi-read-only-file-system-raspbian-1360cf94bace](https://grafolean.medium.com/run-docker-on-your-raspberry-pi-read-only-file-system-raspbian-1360cf94bace)
I have followed both, but was not successfully with running app in Docker and read-only mode for Raspberry PI Zero. There is 512MB of ram, and
the Docker image is pretty big. If you are running on Rpi 2B+ with more than 512MB, I expect you will succeed with read-only file system and Docker.

So, if you do not want to run in Docker, follow steps only from the first guide and first improvements chapter from the second one. The only difference I needed to do, is
to prefix mount commands in `/etc/bash.bash_logout` with sudo. Eg:
```
sudo mount -o remount,ro /
sudo mount -o remount,ro /boot
```
### 8 Use multiple wifi connection profiles
You probably want the RPI be able connect on multiple wifi networks. One from home (during development and testing), the second from your weekend house.
The initial wifi credentials for Raspberry PI OS was set via Imager tool.

To add another wifi profile, do following steps. (Ensure, you are in read-write mode) This will generate the text, you need to copy to `wpa_supplicant.conf`
```
sudo wpa_passphrase my_SSID my_password
```

Paste it in file:
```
sudo vim /etc/wpa_supplicant/wpa_supplicant.conf
```

More info you can find at [https://raspberrypi.stackexchange.com/questions/11631/how-to-setup-multiple-wifi-networks](https://raspberrypi.stackexchange.com/questions/11631/how-to-setup-multiple-wifi-networks) 
Also, you can set the priority.

The `wpa_supplicant.conf` looks now like this:  
```
country=SK
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
ap_scan=1

update_config=1
network={
	ssid="chata"
	#psk="your-password"
	psk=bff8df...........
	priority=3
}

network={
	ssid="Chata"
	#psk="your-password"
	psk=a496f12...........
	priority=2
}
network={
	ssid="Matho-2"
	psk=785b22c78...........
}
```

If you want to change the connection to another SSID based on this settings, without reboot, run following commands:  
```
sudo systemctl daemon-reload
sudo systemctl restart dhcpcd
```
Note: You will be disconnected from your rpi, if the connection profile will be changed. Also, you will have assigned new IP address. 

## 9 Smart plug IP reservation
It is not recommended to keep DHCP to assign address IP for your smart plug. If you are doing port forwarding for given smart plug IP, you need 
to setup address reservation.

I have used the answer from [https://community.tp-link.com/en/home/forum/topic/96168](https://community.tp-link.com/en/home/forum/topic/96168):  

_The best way is to do this at your router, if it supports "Address Reservation". Find the HS100 under its current IP address in your router's Client List, and note down the MAC address. Now navigate to the router's Address Reservation menu and enter the MAC address and the required IP address. Whenever the HS100 reboots (eg when it is powered off and then on) it will be given this same address._



## 10 TODOs
- add display redrawer specs
- when app is (re)started, redraw screem, to white, for example
- cloning external libraries during Docker build from this project repo / or ftp under my control
- do not do git clone of master branch of WiringPi library, but specific tag, to be sure things doesnt break in future
- persist logs, instead of stdout only
- implement log rotation and deletion, to save disk space
