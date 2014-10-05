---
title: Create Your Own Heroku in 10 Minutes
collection: posts
date: 2014-10-04
template: post.jade
---

So maybe you've outgrown Heroku, or you want more power, flexibility or control. Or, maybe you just want to tell your friends you built your own Heroku in 10 minutes. Whatever your reasons, I'd love you show you how simple it can be to create a Heroku-like system using EC2, Docker and Longshoreman. With that said, let's get going.

## Longshoreman

Longshoreman is a deployment system that allows you to build a Docker-powered app cluster on multiple machines. Some of it's features include: zero-downtime rollouts, deployment history and rollbacks, app instance scaling and more great stuff. [Read more about Longshoreman](/introducing-longshoreman) or [visit the GitHub page](http://longshoreman.io).

## Create a Load Balancer

The load balancer is the main entry point for web traffic into the system. We're using AWS's Elastic Load Balancer in this example.

1. Begin by giving your LB a name and configuring its open ports. You can configure SSL here too if you'd like.

<img height="500" src="http://i.imgur.com/kKMIg64.png">

1. Make sure your LB is configured to ping the `/_ping` location for the health check. Longshoreman will respond with 200 if it's alive.

<img height="500" src="http://i.imgur.com/JktIsvO.png">

1. Create a new security group for your LB. I used `lsm-lb`.

<img height="500" src="http://i.imgur.com/X2ZT4KO.png">

1. Skip the next few steps and launch your load balancer. Take a nice deep breath.

## Create a Cluster Node

1. Let's stand up a couple of EC2 instances. For this example we're going to avoid Amazon's VPC option for simplicity's sake. However it's can be a good idea to use private networking when it's available (we do in production).

1. Select the HVM version of Ubuntu 14.04.

<img height="500" src="http://i.imgur.com/cxv3ru8.png">

1. We'll select m3.large instances so our apps don't explode with a few users.

<img height="500" src="http://i.imgur.com/f8jJPCi.png">

1. Next, Add more storage so Docker has some room to store it's container images.

<img height="500" src="http://i.imgur.com/XcbsrAP.png">

1. Give your special snowflake a name.

<img height="500" src="http://i.imgur.com/1XJ6ECq.png">

1. Configure the instance's security group to allow web traffic from the load balancer only. The ports 8000-8999 are special ports that Longshoreman uses to provision app instances.

<img height="500" src="http://i.imgur.com/dtHnxAv.png">

1. Launch your instance. You're almost done.

## Set Up a Domain

Longshoreman can work with multiple domains (all pointed at the same LB), but one common use case is to launch an application to a subdomain. For example, launching an app to `<my-app-name>.mikejholly.com` where `*.mikejholly.com` is configured with a CNAME record pointing to the LB. You'll also need to reserve a subdomain for communication between the Longshoreman and it's CLI tool. We'll be using `lsm.mikejholly.com` in this example.

## Launch a Redis server

Longshoreman stores the state of the cluster in Redis. I'm going to use a micro EC2 instance for this example. You can also use the AWS ElastiCache or RedisLabs for a quick solution.

1. Launch a micro instance (I'm using Ubuntu 14.04 here).

1. Give it a bit more storage than the default (I used 32GB).

1. Configure the Security Group to allow connections to the default Redis port of 6379. Connections should only be allowed from the `lsm-node` Security Group.

<img height="500" src="http://i.imgur.com/FkIgWTv.png">

1. Launch and install Redis with `sudo apt-get install redis-server`. Save the EC2 public DNS name for the next step.

## Configure Docker & Longshoreman

Longshoreman works by deploying instances of your Docker powered app to 1 or more servers. It does this using a CLI application just like Heroku. But the

1. SSH into your new instance. `sudo apt-get update`.

1. Install Docker with `curl -sSL https://get.docker.io/ubuntu/ | sudo sh`.

1. Enable the Docker Remote API by adding the line below to `/etc/default/docker`.

`DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"`

<img height="250" src="http://i.imgur.com/GvHBklo.png">

1. Restart Docker with `sudo service docker restart`.

1. Download and run Longshoreman using the following commands:

`export REDIS_HOST=ec2-255-255-255-255.us-west-2.compute.amazonaws.com` (use your own Redis host here!)

`export CONTROLLER_HOST=lsm.mikejholly.com` (use your own controller host here!)

`sudo docker run -d -p 80:80 -e REDIS_HOST=$REDIS_HOST -e REDIS_PORT=6379 -e CONTROLLER_HOST=$CONTROLLER_HOST longshoreman/longshoreman`

You can optionally pass the `-e DEBUG=longshoreman` flag if you want Longshoreman to print debug information.

## Quick Review

We now have a fully operational Docker powered application cluster managed by Longshoreman. But it can't really do anything without an application, so let's push a very contrived example app to the cluster.

## Launch an Application

1. Run `longshoreman init` to configure your credentials. Enter the Longshoreman controller domain and your token. The token is auto-generated and is stored in Redis. To retrieve your token, run `redis-cli $REDIS_HOST GET token`.

1. To make Longshoreman aware of your nodes run `longshoreman hosts:add <host-ip>`.

1. Add a new service or application to your cluster `longshoreman apps:add demo.domain.com`.

1. `longshoreman --app my.app.domain envs:set NAME=Mike` to configure your application's runtime settings.

1. `longshoreman --app my.app.domain deploy my.docker.reg/repo:tag` to deploy the first version of your application.

1. Point your domain to your load balancer's CNAME and Bob's your uncle.

Thanks a lot for following along! Please give Longshoreman a star on the [GitHub page](http://longshoreman.io) if you think it's cool.
