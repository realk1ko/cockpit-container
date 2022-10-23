![Cockpit Logo](cockpit-logo.png)

# Cockpit via Docker

[![license](https://img.shields.io/github/license/realk1ko/cockpit-docker.svg)](https://github.com/realk1ko/cockpit-docker/blob/master/LICENSE)

> The easy-to-use, integrated, glanceable, and open web-based interface for your servers

_&#8213; https://cockpit-project.org_

## About

The container provided here serves as an alternative installation approach to the Cockpit web interface, also known as
Cockpit Web Service (`cockpit-ws`). It is a fork of the now
defunct [cockpit-container](https://github.com/cockpit-project/cockpit-container) repository
provided ([unintentionally?](https://github.com/cockpit-project/cockpit/issues/17568#issuecomment-1186925794)) by the
Cockpit Project team.

**In it's current state it is a feature stripped version of the original, using the packages from stable Fedora
container image.**

## Usage

The following tags are published to the GitHub Container Registry:

- `latest` refers to the latest (stable) release I'm personally using
- `development` refers to the image built on the last commit on the `main` branch

**Releases are currently built manually and pushed to the registry whenever I manage to do so. However, this is subject
to change.**

Run as you would with any other container from the GHCR:

```
docker run \
    -d \
    --name cockpit \
    -v cockpit:/etc/cockpit \
    -p 9090:9090 \
    ghcr.io/realk1ko/cockpit-docker
```

The created `cockpit` volume maps to the configuration directory `/etc/cockpit` which should contain all configuration
files needed by Cockpit, just as it would be if Cockpit was installed natively. Therefore you can refer to the Cockpit
guides on customization here:

- https://cockpit-project.org/guide/latest/cockpit.conf.5
- https://cockpit-project.org/guide/latest/https

Per default the web interface binds to port 9090. Access that port using `https://<YOUR_HOSTNAME>:9090/` to get started.

## Why provide/use Cockpit as Container?

Cockpit's design in regards to the web interface is - in my opinion - a bit cumbersome. It has several drawbacks that I
think make it less useful than a containerized approach to hosting the web interface in addition to the native
installation:

1. By design **at least one host** is required to have the web interface installed. It may or may not be a host managed
   via Cockpit. However, if that host for some reason is inaccessible (unexpected downtime for instance), you lose
   access to the other hosts managed via Cockpit, unless you install the web interface on those aswell.
2. Installing multiple web interfaces requires **administrative work** (like generating certificates for each host).
3. Additionally you would need **direct access to all managed hosts**, unless you setup a **load balancer across all web
   interfaces**, because in some cases the direct access is simply not an option.
4. The UI will **not store machine configurations** (connections you have created in the UI) **on all other web
   interface hosts** aside from the one you created the connection on. In other words: Everytime you switch the web
   interface host, you will have to recreate the connections. **To be fair, this is not better when using the
   containerized approach.**

Using the containerized approach, you can reduce the effort needed for setup and the regular administrative work, when
hosting the container(s) on the edge of your network. In essence, you avoid the setup of Cockpit Web Service on all
machines and don't really need a load balancer anymore. Direct access to the machines, is also not required then.

## Drawbacks/TODOs

1. **Machine configurations are not stored:** Everytime you login on a host you need to enter it's hostname. If you
   decide to create connections via the sidebar after logging in, be warned: The connections are not saved.
2. **SSH authentication is planned but not supported right now.**
