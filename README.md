# AXP Dev Docker Image
[![Ubuntu 16.04](https://img.shields.io/badge/ubuntu-16.04-brightgreen.svg)]() 
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/chathurabuddi/axp-dev/blob/master/LICENSE) 
[![Docker Pulls](https://img.shields.io/docker/pulls/chathurabuddika/axp-dev.svg)](https://hub.docker.com/r/chathurabuddika/axp-dev/) 
[![Docker Stars](https://img.shields.io/docker/stars/chathurabuddika/axp-dev.svg)](https://hub.docker.com/r/chathurabuddika/axp-dev/) 
[![Docker image](https://images.microbadger.com/badges/image/chathurabuddika/axp-dev.svg)](https://hub.docker.com/r/chathurabuddika/axp-dev/)  
This docker image is configured and pre installed all dependancies for running AXP and WSO2 products such as AXP Digital Enablement Platform (DEP), WSO2 Identity Server and WSO2 Enterprise Integrator.

#### Pre-installed Dependencies
The following dependancies are pre-installed and configured for AXP developmnet environment.
- Java Development Kit 1.8.0_131
- MySQL 5.7.32
- Maven 3.6.3
- Git 2.7.4

#### Run the Image
```
docker run --name axp-dev -e MYSQL_ROOT_PASSWORD=[password] -d -p 3306:3306 -p 8243:8243 -p 8280:8280 -p 9443:9443 -p 9444:9444 -p 9445:9445 -p 5005:5005 axp-dev:[tag]
```

#### Issues
Please make sure to read the 
[issue reporting checklist](https://github.com/chathurabuddi/axp-dev/blob/master/CONTRIBUTING.md#issue-reporting-guidelines) 
before opening an issue. Issues not conforming to the guidelines may be closed immediately.

#### Contribution
Contributions, issues and feature requests are welcome. Feel free to check 
[issues page](https://github.com/chathurabuddi/axp-dev/issues) 
if you want to contribute. Please make sure to read the 
[contributing guide](https://github.com/chathurabuddi/axp-dev/blob/master/CONTRIBUTING.md) 
before making a pull request.

#### License
Copyright © 2019 Chathura Buddhika ([chathurabuddi](http://chathurabuddi.lk))  
This project is [MIT](http://opensource.org/licenses/MIT) licensed.
