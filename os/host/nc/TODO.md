# Postfix

## postscreen

```
postscreen_blacklist_action = enforce
postscreen_access_list = permit_mynetworks
postscreen_dnsbl_action = enforce
postscreen_dnsbl_sites =
  zen.spamhaus.org*3,
  bl.spameatingmonkey.net*2,
  bl.spamcop.net,
  dnsbl.sorbs.net,
  swl.spamhaus.org*-4,
  list.dnswl.org=127.[0..255].[0..255].0*-2,
  list.dnswl.org=127.[0..255].[0..255].1*-4,
  list.dnswl.org=127.[0..255].[0..255].[2..3]*-6
postscreen_greet_action = enforce
postscreen_cache_map = btree:${data_directory}/postscreen_cache
```

## Spam

No idea what this does.

```
# https://pepipost.com/tutorials/setup-spf-and-dkim-with-postfix-on-ubuntu/
# config for installed package: postfix-policyd-spf-python
#policyd-spf_time_limit = 3600
smtpd_recipient_restrictions =
  permit_mynetworks,
  permit_sasl_authenticated,
  reject_rhsbl_helo dbl.spamhaus.org,
  reject_rhsbl_reverse_client dbl.spamhaus.org,
  reject_rhsbl_sender dbl.spamhaus.org,
  reject_unauth_destination
#  check_policy_service unix:private/policyd-spf,
#  check_policy_service inet:127.0.0.1:10023 
```

## Milter for OpenDKIM and OpenDMARC

```
milter_default_action = accept
milter_protocol = 6
smtpd_milters = local:opendkim/opendkim.sock,local:opendmarc/opendmarc.sock
non_smtpd_milters = $smtpd_milters
```


## Message Size Limits

```
# 512MiB
message_size_limit = 536870900
```

## Other

```
compatibility_level = 2

myhostname = mx.leutgeb.xyz
mydomain = leutgeb.xyz
myorigin = /etc/mailname
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128

inet_interfaces = all
inet_protocols = all

smtpd_banner = $myhostname ESMTP $mail_name
biff = no
append_dot_mydomain = no
readme_directory = no

virtual_alias_domains = $mydomain
virtual_alias_maps = hash:/etc/postfix/virtual
#virtual_transport = lmtp:unix:private/dovecot-lmtp
local_transport = lmtp:unix:private/dovecot-lmtp
#local_transport = virtual
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
#local_recipient_maps = 
luser_relay = lorenz+$user

smtpd_tls_cert_file = /etc/letsencrypt/live/leutgeb.xyz-wildcard/fullchain.pem
smtpd_tls_key_file = /etc/letsencrypt/live/leutgeb.xyz-wildcard/privkey.pem
smtpd_tls_dh1024_param_file = /etc/letsencrypt/dhparams/2048.pem
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtpd_tls_security_level = may
smtpd_tls_auth_only = yes
smtpd_tls_protocols = !SSLv2,!SSLv3,!TLSv1,!TLSv1.1
smtpd_tls_mandatory_ciphers = medium
smtpd_tls_loglevel = 1

smtpd_sasl_auth_enable = yes
smtpd_sasl_type=dovecot
smtpd_sasl_path=private/auth

smtp_sasl_security_options=noanonymous

tls_preempt_cipherlist = yes

smtpd_relay_restrictions = permit_auth_destination permit_mynetworks permit_sasl_authenticated defer_unauth_destination

smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
smtp_tls_mandatory_protocols = !SSLv2,!SSLv3,!TLSv1,!TLSv1.1
smtp_tls_security_level = may
smtp_tls_mandatory_ciphers = high
smtp_tls_loglevel = 1

# Defaults to $myhostname, but the PTR of
# this server's IP points at leutgeb.xyz,
# so we need to override.
smtp_helo_name = leutgeb.xyz

mailbox_size_limit = 0
recipient_delimiter = +
```
