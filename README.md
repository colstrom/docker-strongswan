# Strongswan on Docker

Base docker image to run a Strongswan IPsec and a XL2TPD server.

## Build Docker Image

Run the following to build a images:
```
docker build -t strongswan .
```

## Usage

Run the following to start the container:

```
docker run -d  -e VPN_USER=nilesh -e VPN_PASSWORD=password -e VPN_PSK=psk -d -p 500:500/udp -p 4500:4500/udp -p 1701:1701/udp --privileged  cloudgenius/strongswan
```

Build and push the docker image

Strongswan on docker

```
git clone https://github.com/beacloudgenius/docker-strongswan.git
docker build -t cloudgenius/strongswan .
docker push cloudgenius/strongswan
```

### run without specifying USER, PASSWORD, and PSK

```
docker run -d -p 500:500/udp -p 4500:4500/udp -p 1701:1701/udp --privileged philplckthun/strongswan
```

If you haven't set any login credentials via configuration files or environment variables, then new random password and psk will be set. The username will be set as `user`.

To get it, read the logs of the running container:

```
docker logs <CONTAINER>
```

Search for this line in the output at the top:

```
No VPN_PASSWORD set! Generated a random password: mrXEv2S3F
No VPN_PSK set! Generated a random PSK key: NZESSabnC
```

Here, the user hasn't set a PSK secret and password.

## Environment variables

By default a single account is added for EAP and XAuth login.

Its password is specified by the `VPN_PASSWORD` environment variable, and its username is specified by the `VPN_USER` variable.

`VPN_USER` defaults to `user` and `VPN_PASSWORD` is randomized if not changed.

The PSK (pre-shared key) is specified in the `VPN_PSK` environment variable, and is randomized as well.

You can inject these variables through `docker run`:

```
docker run ... -e VPN_USER=dave VPN_PASSWORD=dave-is-awesome ...
```

## Volume / Configuration files

There is a single volume that is mounted at `/etc/ipsec.d`. Through it you can add a lot of Strongswan configuration. Additionally you can overwrite:

* /etc/ppp/l2tp-secrets
* /etc/ipsec.secrets
* /etc/ipsec.conf
* /etc/strongswan.conf
* /etc/xl2tpd.conf

with it, by putting your configuration files in that volume folder as well. They will be copied to the correct locations.

## Services running

There are two services running: *Strongswan* and addtionally *XL2TPD* for IPSec/L2TP support.

The default IPSec configuration supports:

* IKEv2 with EAP Authentication (Though a certificate has to be added for that to work)
* IKEv2 with PSK
* IKEv1 with PSK and XAuth (Cisco IPSec)
* IPSec/L2TP with PSK

The ports that are exposed for this container to work are:

* 4500/udp and 500/udp for IPSec
* 1701/udp for L2TP
