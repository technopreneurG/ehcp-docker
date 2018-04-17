# EHCP - Docker

An attempt to Dockerize [EHCP](http://www.ehcp.net/).


WARNING:
* I have not tested it in production environment. I encourage you
  to try it out in your local/development setup.
* Not production ready yet.

TODO:
* Fix volumes list to preserve data like (configs/logs/...)
* Test it out in production


## Instructions
### Requirements
* install docker & docker-compose, follow these links to get started:
  * https://docs.docker.com/install/
  * https://docs.docker.com/compose/install/

### Build & Run
* git clone this repo
* environment file and settings
```shell
$ cp sample.env .env
$ vi .env
```
* build the images
```shell
$ docker-compose build
```
* (re)create, start services
```shell
$ docker-compose up -d
```
* Stop containers
```shell
$ docker-compose down
```
* go to http://yourhost/ehcp
