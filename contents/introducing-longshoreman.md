---
title: Introducing Longshoreman
collection: posts
date: 2014-08-20
template: post.jade
---

Longshoreman is a Docker container orchestration system that facilitates the deployment of Docker-based application instances across multiple server nodes. It was created at [Wayfinder](http://wayfinder.co) to help launch our micro-service-based infrastructure.

## Docker Deployment Landscape

Docker is truly an incredible new technology. Watching the project's growth over the last year or so has been extremely exciting for me. I've always felt that deployment with configuration management tools like Chef, Puppet or Ansible has been a bit verbose and onerous and Docker's notion of immutable infrastructure seems like a quantum leap in the right direction to me.

We've also been drinking the micro-service Kool-Aid at [Wayfinder](http://wayfinder.co) for the last several months. Moving away from a monolithic design toward a micro-service approach has been incredibly rewarding both as a developer and as a team. Our software is simpler, more scalable and things get done more quickly and with less debate (I suspect this is a side-effect of extremely simple components).

Like many, we had been using Heroku to deploy our production services. But Heroku is at the same time both very simple and quite limited. As someone who has deployed systems at scale using AWS, I longed for more power and control. Heroku provides flexibility via tools like Build Packs, but I found these to be rather irritating to configure and customize. (I'm also lazy—which I've heard is a virtue amongst developers).

So naturally, we looked to Docker for a solution. Removing the need for deployment and configuration tools like Chef or Puppet, while providing rich control over our application environments seemed like a big win. The ability to move to different infrastructure service providers based on cost was extremely desirable as well.

After deciding that Docker was the right tool for the job we started exploring deployment options. I spent a few days researching tools and experimenting with several options ([check out this Hackpad](https://hackpad.com/Infrastructure-ox7KgPtqwIa) for my findings). The biggest contender was [Deis](http://deis.io), a very promising solution based on CoreOS and Docker. I ran into a few issues with Deis (outlined in the Hackpad above) that gave me the impression it wasn't quite ready for prime time.

<img height="180" style="float:right;" src="http://i.imgur.com/RuqDnPk.png">

## Enter Longshoreman

And so, after some consideration, we decided to roll our own Docker deployment solution. It's a complete container deployment system written in Node.js—we call it [Longshoreman](http://longshoreman.io).

As of right now, Longshoreman does three things:

1. It manages the deployment of Docker containers to a collection of server nodes.
2. It facilitates the routing of web traffic through to these container instances.
3. It allows developers to administer this Docker-powered cluster with a handy CLI.

Here's a diagram to help illustrate how it works.

![Diagram](http://i.imgur.com/I0POpX4.png)

You can read more detail about each component at the [project page](http://longshoreman.io).

## More to Come

We're working away on some exciting new features that will take Longshoreman to the next level. Intelligent scaling and distribution of services, the ability to snapshot, export and import your container setup, and a DNS option for service discovery are on the horizon. We've also been experimenting with Continuous Deployment work-flows with [CircleCI](http://www.circleci.com) which we'll be sharing soon.
