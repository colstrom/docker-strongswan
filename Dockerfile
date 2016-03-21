FROM alpine:edge

RUN mkdir -p /conf

RUN apk --update-cache add \
  gmp \
  iptables \
  xl2tpd \
  strongswan && \
  rm -rf /var/cache/apk/* /tmp/*

# Strongswan Configuration
ADD ipsec.conf /etc/ipsec.conf
ADD strongswan.conf /etc/strongswan.conf

# XL2TPD Configuration
ADD xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
ADD options.xl2tpd /etc/ppp/options.xl2tpd

ADD run.sh /run.sh
ADD vpn_adduser /usr/local/bin/vpn_adduser
ADD vpn_deluser /usr/local/bin/vpn_deluser
ADD vpn_setpsk /usr/local/bin/vpn_setpsk
ADD vpn_unsetpsk /usr/local/bin/vpn_unsetpsk
ADD vpn_apply /usr/local/bin/vpn_apply

# The password is later on replaced with a random string
ENV VPN_USER user
ENV VPN_PASSWORD password
ENV VPN_PSK password

VOLUME ["/etc/ipsec.d"]

EXPOSE 4500/udp 500/udp 1701/udp

CMD ["/run.sh"]
