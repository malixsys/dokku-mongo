# dokku mongo (beta) [![Build Status](https://img.shields.io/travis/dokku/dokku-mongo.svg?branch=master "Build Status")](https://travis-ci.org/dokku/dokku-mongo) [![IRC Network](https://img.shields.io/badge/irc-freenode-blue.svg "IRC Freenode")](https://webchat.freenode.net/?channels=dokku)

Official mongo plugin for dokku. Currently installs [mongo 3.0.6](https://hub.docker.com/_/mongo/).

## requirements

- dokku 0.4.0+
- docker 1.8.x

## installation

```
cd /var/lib/dokku/plugins
git clone https://github.com/dokku/dokku-mongo.git mongo
dokku plugins-install-dependencies
dokku plugins-install
```

## commands

```
mongo:alias <name> <alias>     Set an alias for the docker link
mongo:clone <name> <new-name>  NOT IMPLEMENTED
mongo:connect <name>           Connect via telnet to a mongo service
mongo:create <name>            Create a mongo service
mongo:destroy <name>           Delete the service and stop its container if there are no links left
mongo:export <name>            NOT IMPLEMENTED
mongo:expose <name> [port]     Expose a mongo service on custom port if provided (random port otherwise)
mongo:import <name> <file>     NOT IMPLEMENTED
mongo:info <name>              Print the connection information
mongo:link <name> <app>        Link the mongo service to the app
mongo:list                     List all mongo services
mongo:logs <name> [-t]         Print the most recent log(s) for this service
mongo:restart <name>           Graceful shutdown and restart of the mongo service container
mongo:start <name>             Start a previously stopped mongo service
mongo:stop <name>              Stop a running mongo service
mongo:unexpose <name>          Unexpose a previously exposed mongo service
```

## usage

```shell
# create a mongo service named lolipop
dokku mongo:create lolipop

# you can also specify the image and image
# version to use for the service
# it *must* be compatible with the
# official mongo image
export MONGO_IMAGE="mongo"
export MONGO_IMAGE_VERSION="3.0.5"
dokku mongo:create lolipop

# get connection information as follows
dokku mongo:info lolipop

# lets assume the ip of our mongo service is 172.17.0.1

# a mongo service can be linked to a
# container this will use native docker
# links via the docker-options plugin
# here we link it to our 'playground' app
# NOTE: this will restart your app
dokku mongo:link lolipop playground

# the above will expose the following environment variables
#
#   MONGO_URL=mongo://172.17.0.1:27017
#   MONGO_NAME=/lolipop/DATABASE
#   MONGO_PORT=tcp://172.17.0.1:27017
#   MONGO_PORT_27017_TCP=tcp://172.17.0.1:27017
#   MONGO_PORT_27017_TCP_PROTO=tcp
#   MONGO_PORT_27017_TCP_PORT=27017
#   MONGO_PORT_27017_TCP_ADDR=172.17.0.1

# you can customize the environment
# variables through a custom docker link alias
dokku mongo:alias lolipop MONGO_DATABASE

# you can also unlink a mongo service
# NOTE: this will restart your app
dokku mongo:unlink lolipop playground

# you can tail logs for a particular service
dokku mongo:logs lolipop
dokku mongo:logs lolipop -t # to tail

# finally, you can destroy the container
dokku mongo:destroy lolipop
```

## todo

- implement mongo:clone
- implement mongo:import
