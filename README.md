![Cockpit Logo](cockpit-logo.png)

# Cockpit Container

[![License](https://img.shields.io/github/license/realk1ko/cockpit-container.svg)](https://github.com/realk1ko/cockpit-container/blob/main/LICENSE)

> The easy-to-use, integrated, glanceable, and open web-based interface for your servers

_&#8213; https://cockpit-project.org_

## About

The container provided here serves as an alternative installation approach to the Cockpit web interface, also known as
Cockpit Web Service (`cockpit-ws`).

## Tags

The following tags are published to the GitHub Container Registry:

- The `:latest` tag is updated within a day of a new release of the Cockpit packages for Fedora.
- The `:dev` tag refers to the image automatically built on the last commit on the `dev` branch. **Please do not use
  this.**
- Additionally each published image is tagged with the installed Cockpit version (e. g. `:280`). Refer to the packages
  overview [here](https://github.com/users/realk1ko/packages/container/package/cockpit) for more info.

## Usage

### TL;DR

```
docker run \
    -d \
    --name cockpit \
    -v cockpit:/etc/cockpit \
    -p 9090:9090 \
    ghcr.io/realk1ko/cockpit
```

The `cockpit` volume maps to the configuration directory `/etc/cockpit` which contains all relevant files for Cockpit,
same as with a native installation.

### Configuration

In case the `cockpit.conf` file is missing in the `/etc/cockpit` directory on startup, the
default [configuration template](https://github.com/realk1ko/cockpit-container/blob/main/container/usr/local/etc/cockpit-container/cockpit.conf.template)
will be copied there. For customizing the `cockpit.conf` file you can refer to the following guides:

- https://cockpit-project.org/guide/latest/cockpit.conf.5
- https://cockpit-project.org/guide/latest/guide

### Certificates

On start Cockpit will generate a self signed certificate to use for TLS. You can instead provide a custom certificate to
Cockpit by adding the files (`*.crt` and `*.key`) to the `/etc/cockpit/ws-certs.d` directory or mounting the files.

```
-v /path/to/your/cert.crt:/etc/cockpit/ws-certs.d/cert.crt:ro \
-v /path/to/your/cert.key:/etc/cockpit/ws-certs.d/cert.key:ro
```

### Connecting to Hosts

Make sure that the managed host is reachable by the container and has both SSH enabled and
the Cockpit core packages (`cockpit-system`) installed. The connection between the container and the managed host will
then be done via SSH.

Per default the web interface binds to port `9090`. To connect to a managed host, visit the web
interface via `https://<YOUR_CONTAINER_HOST>:9090/` and login using the credentials of the managed host and it's
hostname.

On login you will be prompted to verify the SSH public key fingerprint of the managed host, if it's not defined in
`/etc/ssh/ssh_known_hosts`. Approved fingerprints will then be stored in your browser for the next login.

```
-v /host/path/to/known_hosts:/etc/ssh/ssh_known_hosts:ro
```

You can also specify the `known_hosts` file Cockpit will use to check fingerprints.

```
-v /host/path/to/known_hosts:/container/path/to/known_hosts:ro \
-e COCKPIT_SSH_KNOWN_HOSTS_FILE=/container/path/to/known_hosts
```

### SSH Key Authentication

The default template for the `cockpit.conf` only allows username and password authentication.

However, the image comes pre-packaged with an
[utility](https://github.com/realk1ko/cockpit-container/blob/main/container/usr/local/bin/cockpit-auth-ssh-key) created
by
the [Cockpit Project Team](https://github.com/cockpit-project) that allows you to use a **single** specific SSH key as
identity for Cockpit when connecting to managed hosts.

To use key authentication you will need to append the following lines to the `cockpit.conf` file:

```
[Basic]
Command = /usr/local/bin/cockpit-auth-ssh-key

[Ssh-Login]
Command = /usr/local/bin/cockpit-auth-ssh-key
```

Per default the container will use the key stored at `/etc/cockpit/identity`, if it exists. You can provide such a file
or override the path to your key using the `COCKPIT_SSH_KEY_PATH` environment variable.

```
-v /host/path/to/key:/container/path/to/key:ro \ 
-e COCKPIT_SSH_KEY_PATH=/container/path/to/key
```

The password you enter in the web interface to connect to a managed host is used to decrypt the SSH key. If for some
reason the decryption fails, the password will be transmitted to the managed host for username/password authentication.

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
   interface host, you will have to recreate the connections. **To be fair, this is the same when using the
   containerized approach.**

Using the containerized approach, you can reduce the effort needed for setup and the regular administrative work, when
hosting the container(s) on the edge of your network. In essence, you avoid the setup of Cockpit Web Service on all
machines and don't really need a load balancer anymore. Direct access to the machines, is also not required then.
