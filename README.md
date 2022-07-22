# Smart Ruby Plug

Do you want to reduce monthly energy costs of your Starlink Internet connection? 

The project has 3 repositories
- [Matho/smart_ruby_plug](https://github.com/Matho/smart_ruby_plug) - this is main Ruby project
- [Matho/smart_ruby_plug_c](https://github.com/Matho/smart_ruby_plug_c) - C source code for those, who want to change the drawing on the Raspberry Pi display
- [Matho/smart_ruby_plug_c_binaries](https://github.com/Matho/smart_ruby_plug_c_binaries) - prebuilded C binaries (.so file) for those, who do not want to build the binary from source code

You can find the **demo video** at [this link](http://websupport.matho.sk/smart_plug.webm)

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
- you have to buy 2x Raspberry Pi (preferred is Raspberry Pi 4B, but you can use any aarch64 supported, like Raspberry Pi 3B and higher) 2GB memory model should be good enough
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
- 2x Raspberry Pi 2GB model ... 2x51 EUR
- 2x power adapter .. 2x10EUR
- 2x ethernet cable ... 2x1.5EUR
- 2x micro SD card ... 2x8EUR
- 2x some rpi case ... optional
- shipping for orders from eshops ... unknown/optional

Total*: 195 EUR

**Note:** The yearly energy bill is expected at `430Kwh` It should cost about 100 EUR / year. 
I expect you can sell the used items on bazaar after few years with 70% of buy price,
so **your initial costs in this case would be only 59 EUR.** Also, you need to include here the saved energy costs.

**Note 2:** For the remote device rpi, maybe you could use Raspberry PI Zero 2W. This model is aarch64 compatible. When you use Ubuntu Core distribution, it could be running. But it has not been tested yet.

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

You can check to turn on/off the plug via Home Assistant, or via REST API. The REST APIs doc is at [https://developers.home-assistant.io/docs/api/rest/](https://developers.home-assistant.io/docs/api/rest/)

### 3.3 SmartRubyPlug installation
You need to install the Ubuntu OS to the rpi device, which will act as remote controller.

You can use Raspberry Pi's Imager to prepare bootable micro SD card. Select Ubuntu 22.04 aarch64 for Raspberry Pi 4B. 
Once the card is prepared, insert it into rpi. The default user is ubuntu and password is `ubuntu`. You will be requested to 
change the password immediately. You can set ssh keys to do not require copy paste the password for each login.

If you dont want to use ethernet port for internet, but wifi instead, I recommend to check this article [https://arstech.net/raspberry-pi-4-ubuntu-wifi/](https://arstech.net/raspberry-pi-4-ubuntu-wifi/)

**The easiest way is install this project via Docker**. See chapter `6. Dockerfile building and running via Docker` for more info.

Now we need to install [RVM](https://rvm.io/). RVM is Ruby Version Manager and with RVM you can install multiple Ruby language versions in the same OS and switch between versions easily.

Install GPG keys:  
`sudo apt install gnupg2`  
`gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB`

Install RVM:
```
curl -sSL https://get.rvm.io | bash -s stable
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

Download this SmartRubyPlug project to the home folder, eg to `/home/ubuntu/smart_ruby_plug`. Alternatively, you can use FileZilla to upload code.
Navigate to `cd ~/smart_ruby_plug`. You should be asked to switch to RVM Ruby version from project. Type `y` to yes and `enter`.
Install the Ruby version, the RVM is asking to install. 
```
rvm install "ruby-3.1.2"
```
This could take few minutes, it will compile Ruby, if no binaries are found. 

After Ruby is installed, you can install project dependencies.   
`gem install bundler`  
`bundle install`

Then you need to copy the prebuilded C `.so` file. This file should be in the following project path: `lib/clibrary/libsmart_plug_C.so`
After it, you can run the project by executing `bin/smart_ruby_plug start` from the project root.

Note: Enable SPI interface
```
sudo apt-get install raspi-config
sudo raspi-config
# Choose Interfacing Options -> SPI -> Yes  to enable SPI interface
sudo reboot
```
The display should be working now.

### 3.4 Installing display dependencies and compiling the C source code
The display redrawing and detection for keypress is written via C code. Then, the `main.so` file is prepared and Ruby is calling the C functions via `FFI` gem.
If you want to compile the C code instead of using the prebuilded binary, you can follow this steps.

**NOTE:** I expect, you need to install `BCM2835 libraries` and `wiringPi libraries` in the following steps also for cases, you would like to run on the prebuilded binary, without custom compilation.

The instructions are extracted from [https://www.waveshare.com/wiki/1.3inch_LCD_HAT](https://www.waveshare.com/wiki/1.3inch_LCD_HAT)

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

Because we are not using Python source code examples, we do not need to install Python. 
Also, we do not need to install FBCP driver as we are not displaying the OS GUI screens, but only drawing, like on canvas. (TODO verify, it FBCP driver could improve drawing performance, or not)

Download the C project repository code to `~/smart_ruby_plug_c`

To build the C project on rpi, you need to install following dependencies:
```
sudo apt-get install gcc doxygen cmake gdb
```

Build the project via Makefile (or via Clion IDE, if you have configured it correctly):
```
make clean
make
```
You should see new `main.so` file. You can prepare symlink for Ruby project:
```
ln -s /home/ubuntu/smart_ruby_plug_c/main.so /home/ubuntu/smart_ruby_plug/lib/clibrary/libsmart_plug_C.so 
```

If you are going to do more work with this C project, you can setup `Clion IDE` settings to synchronize target files with your local files in IDE and run 
the building on rpi. The building works only on compatible raspberry pi, it will fail on your localhost. The instruction can be found on [https://www.jetbrains.com/help/clion/remote-projects-support.html](https://www.jetbrains.com/help/clion/remote-projects-support.html)

Start the ruby app:
```
cd ~/smart_ruby_plug
bin/smart_ruby_plug start
```

**Using custom fonts:**  
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

Create new file:
``` 
sudo vim /etc/systemd/system/smart_ruby_plug.service
```

and insert there:
```
[Unit]
After=

[Service]
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
`bin/smart_ruby_plug start`

**Note:** You need to push the button for 2 seconds. Only the light click for few miliseconds doesnt register the key press event.

## 5. Running tests
Log in to your raspberry pi, `cd` to the project and run:
`rspec .`

The project need the prebuilded `.so` file. 


## 6. Dockerfile building and running via Docker

### 6.1 Install Docker
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
Use proper architecture - `arm64` for > Raspberry Pi 3B or `armhf` for < Raspberry Pi 2B
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

### 6.2 Build this image
`cd ~/docker-builds/smart_ruby_plug`  
Pass `--no-cache` for clean build and pass correct url with C binary version for C_BINARY_PATH arg.

For aarch64:  
`sudo docker build -t mathosk/smart_ruby_plug:v0.1.0.beta_aarch64 --build-arg ARCH=aarch64 --build-arg C_BINARY_PATH=https://github.com/Matho/smart_ruby_plug_c_binaries/releases/download/v0.1.0.beta/libsmart_plug_C.so.v0.1.0.beta_77865ad7af .`

Alternatively for armv7l:  
`sudo docker build -t mathosk/smart_ruby_plug:v0.1.0.beta_armv7l --build-arg ARCH=armv7l --build-arg C_BINARY_PATH=https://github.com/Matho/smart_ruby_plug_c_binaries/raw/master/armv7l_32/v0.1.0/libsmart_plug_C.so.v0.1.0.beta_77865ad7af .`

### 6.3 Execute
`-d` means detached - running in background. If you do not want to run it in background (for test purposes) remove `-d` option from command line

```
sudo docker run --privileged -d mathosk/smart_ruby_plug:v0.1.0.beta 
```

**Note:** amd64 arch is not prebuilded, as you need to run this sw on the Raspberry Pi. 

#### 6.3.1 Docker Compose
You need to have installed the `docker-compose` package. Check it via:
`docker-compose --version`

Copy `smart_ruby_plug/config/settings.yml` file with modified yml according your needs and upload it to folder
`/data/smart_ruby_plug/config` on your Raspberry Pi. 

The docker-compose file is located in this project root. Please, before you start it, point to correct version you want to pull.

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

## 7. TODOs
- add display redrawer specs
- tag and push to RubyGems, once ready to use it in production