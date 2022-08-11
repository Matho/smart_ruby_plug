## 0.4.0 (unreleased)
- make faster wifi checks and smart plug on request (60 seconds to 2 seconds)
- reduce ping timeout
- fix closing SPI file descriptor

## 0.3.0 
- add armv6 bash start scripts
- add info about read-only file system
- fix issue, when Home Assistant node was down, the internet requests was scheduled each 3 seconds instead of default 30 seconds
- readme improvements

## 0.2.0
- fix issue, when Home Assistant node was not reachable and the exception was bubbling up, which caused app exit
- fix the case, when app was exited, if wifi or internet IP was not reachable
- fix missing ping package for Docker build

## 0.1.2.beta
- fix gemspec

## 0.1.1.beta
- added Dockerfiles 
- added docker and docker-compose installation doc
- added doc about how to run the project via Docker

## 0.1.0.beta
- initial project release
