{ hardware, lib, pkgs, modulesPath, ... }:

with builtins;

let
  domain = "leutgeb.xyz";
  alternateDomain = "falsum.org";
  subdomain = name: name + "." + domain;
  localMail = localPart: "${localPart}@${domain}";
  alternateLocalMail = localPart: "${localPart}@${alternateDomain}";
  dnsProvider = "cloudflare";
  me = {
    name = "Lorenz Leutgeb";
    username = "lorenz";
    email = localMail me.username;
  };
in {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    "${modulesPath}/virtualisation/qemu-guest-agent.nix"
    #./jitsi.nix
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    autoResize = true;
  };

  boot = {
    growPartition = true;
    kernelParams = [ "console=ttyS0" ];
    kernel.sysctl."net.ipv4.ip_forward" = 1;
    initrd = {
      availableKernelModules = [ ];
      kernelModules = [ ];
    };
    kernelPackages = with pkgs; linuxPackages_5_10;
    kernelModules = [ ];
    loader = {
      grub = {
        enable = true;
        device = "/dev/vda";
      };
      timeout = 5;
    };
  };

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    hostName = "nc";
    defaultGateway = "37.120.164.1";
    interfaces.eth0 = {
      ipv4.addresses = [{
        address = "37.120.164.130";
        prefixLength = 22;
      }];
      ipv6.addresses = [{
        address = "2a03:4000:6:4015::1";
        prefixLength = 64;
      }];
    };
    trustedInterfaces = [ "tailscale0" ];
  };

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    binutils
    coreutils
    exfat
    fuse
    lsof
    nixFlakes
    pflogsumm
    utillinux
    vim
    wget
    which
    zip
  ];

  networking.firewall.allowedTCPPorts = [
    22 # sshd
    25 # postfix (SMTP)
    80 # nginx
    443 # nginx
    465 # dovecot/postfix ? (SMTP over TLS)
    993 # dovecot (IMAP over TLS)
    8384 # syncthing HTTP
  ];

  mailserver = {
    enable = false;
    fqdn = "mx.leutgeb.xyz";
    domains = [ "leutgeb.xyz" ];

    loginAccounts = {
      ${me.email} = {
        hashedPassword =
          "$6$rJZSLnQH1hInB93$lfi4c2zxQbSJV7H9T9lrjOj6WIDhSEqP5FyjMinEE44j81E1l57hF6Epyxb02EbcWqDT9eYbyo4dBTAwewBgQ/";
        aliases = [
          (localMail "root")
          (localMail "webmaster")
          (localMail "l")
          (alternateLocalMail "lorenz")
          (alternateLocalMail "lorenz.leutgeb")
          (alternateLocalMail "l")
        ];
        catchAll = [ "leutgeb.xyz" ];
      };
      ${localMail "daniela"} = {
        hashedPassword =
          "$6$C.yOR4Lf$eadC5gBRv0gb6F/X29GkwIsGioWHWSM/ztlJo4FA4bh4i6aCHMz4.Rm2ABKTS/zThIYcSz1TOj/iK5ohHJLUX/";
      };
    };

    certificateScheme = 1;
    certificateFile = "/var/lib/acme/leutgeb.xyz-wildcard/fullchain.pem";
    keyFile = "/var/lib/acme/leutgeb.xyz-wildcard/key.pem";

    enableImapSsl = true;

    # Enable the ManageSieve protocol
    enableManageSieve = true;

    # whether to scan inbound emails for viruses (note that this requires at least
    # 1 Gb RAM for the server. Without virus scanning 256 MB RAM should be plenty)
    virusScanning = false;

    hierarchySeparator = "/";

    useFsLayout = true;

    messageSizeLimit = 64 * 1024 * 1024; # 64MiBy ought to be enough...

    forwards = let
      anna = "a.leutgeb@hotmail.com";
      daniela = "leutgeb1963@gmail.com";
      ralph = "ralph.leutgeb@gmx.at";
    in {
      ${localMail "a"} = anna;
      ${localMail "anna"} = anna;
      ${localMail "d"} = daniela;
      ${localMail "daniela"} = daniela;
      ${localMail "dany"} = daniela;
      ${localMail "r"} = ralph;
      ${localMail "ralf"} = ralph;
      ${localMail "ralph"} = ralph;
    };
  };

  extraVirtualAliases.${localMail "theres-und-lorenz"} =
    [ "theressophie@gmail.com" "${me.email}" ];

  services = {
    tailscale.enable = true;
    qemuGuest.enable = true;
    openssh = {
      enable = true;
      # Only listen on Tailscale interface.
      # If Tailscale goes down, recover access via netcup vServer Control Panel.
      listenAddresses = [{
        addr = "100.104.93.77";
        port = 22;
      }];
    };

    # Open ports in the firewall.
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    /* dovecot2 = {
          enable = false;
          enableImap = true;
          enableLmtp = true;
        };
    */

    nginx = {
      enable = true;
      virtualHosts = {
        "${domain}" = {
          serverAliases = [
            (subdomain "www")
            (subdomain "mta-sts")
            (subdomain "autoconfig")
          ];
          onlySSL = true;
          enableACME = false;
          useACMEHost = "${domain}";
          locations."/" = { root = "/var/www"; };
        };

        "${alternateDomain}" = {
          serverAliases = [
            (subdomain "www")
            #(subdomain "mta-sts")
            #(subdomain "autoconfig")
          ];
          onlySSL = true;
          enableACME = false;
          useACMEHost = "${alternateDomain}";
          locations."/" = { root = "/var/www/falsum.org"; };
        };

        "${subdomain me.username}" = {
          onlySSL = true;
          enableACME = false;
          useACMEHost = "${domain}-wildcard";
          locations."/" = { root = "/var/www/${subdomain me.username}"; };
        };
      };
    };

    /* postfix = {
          enable = true;
          enableSmtp = true;
          # Submission is handled by Dovecot.
          enableSubmission = false;
          config = let data_directory = "/dev/null";
          in {
            # Added from FF Hamburg.
            mydestination = ""; # ?
            myhostname = (subdomain "mx");
            # mynetworks_style = "host"; # ?
            recipient_delimiter = "+";
            # relay_domains = ""; # ?
            # TODO: Fix paths for OpenDKIM and OpenDMARC milters.
            # TODO: This would be the place to hook rspamd.
            smtpd_liters =
              "local:opendkim/opendkim.sock,local:opendmarc/opendmarc.sock";
            # TODO: Fix paths for SASL. Should hit Dovecot.
            smtpd_sasl_path = "private/auth";
            smtpd_sasl_type = "dovecot";
            smtpd_tls_auth_only = "yes";
            smtpd_tls_chain_files =
              "/var/lib/acme/postfix.${subdomain "mx"}/full.pem";
            smtpd_tls_loglevel = "1";
            smtpd_tls_security_level = "may";

            # Added from my config:
            compatibility_level = "2";

            mydomain = "leutgeb.xyz";
            myorigin = "leutgeb.xyz";
            mynetworks = "127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128";

            inet_interfaces = "all";
            inet_protocols = "all";

            smtpd_banner = "$myhostname ESMTP $mail_name";
            biff = "no";
            append_dot_mydomain = "no";
            readme_directory = "no";

            virtual_alias_domains = "$mydomain";
            virtual_alias_maps = "hash:/etc/postfix/virtual";
            #virtual_transport = "lmtp:unix:private/dovecot-lmtp
            local_transport = "lmtp:unix:private/dovecot-lmtp";
            #local_transport = "virtual
            #alias_maps = "hash:/etc/aliases";
            alias_database = "hash:/etc/aliases";
            #local_recipient_maps =
            luser_relay = "lorenz+$user";

            smtpd_tls_cert_file =
              "/etc/letsencrypt/live/leutgeb.xyz-wildcard/fullchain.pem";
            smtpd_tls_key_file =
              "/etc/letsencrypt/live/leutgeb.xyz-wildcard/privkey.pem";
            smtpd_tls_dh1024_param_file = "/etc/letsencrypt/dhparams/2048.pem";
            smtpd_tls_session_cache_database =
              "btree:${data_directory}/smtpd_scache";
            smtpd_sasl_auth_enable = "yes";
            smtp_sasl_security_options = "noanonymous";

            smtpd_tls_protocols = "!SSLv2,!SSLv3,!TLSv1,!TLSv1.1";
            smtpd_tls_mandatory_ciphers = "medium";
            tls_preempt_cipherlist = "yes";

            smtpd_relay_restrictions =
              "permit_auth_destination permit_mynetworks permit_sasl_authenticated defer_unauth_destination";

            smtp_tls_session_cache_database = "btree:${data_directory}/smtp_scache";
            smtp_tls_mandatory_protocols = "!SSLv2,!SSLv3,!TLSv1,!TLSv1.1";
            smtp_tls_security_level = "may";
            smtp_tls_mandatory_ciphers = "high";
            smtp_tls_loglevel = "1";

            # Defaults to $myhostname, but the PTR of
            # this server's IP points at leutgeb.xyz,
            # so we need to override.
            smtp_helo_name = "leutgeb.xyz";

            mailbox_size_limit = "0";

            # https://pepipost.com/tutorials/setup-spf-and-dkim-with-postfix-on-ubuntu/
            # config for installed package: postfix-policyd-spf-python
            #policyd-spf_time_limit = "3600";
            smtpd_recipient_restrictions =
              "permit_mynetworks, permit_sasl_authenticated, reject_rhsbl_helo dbl.spamhaus.org, reject_rhsbl_reverse_client dbl.spamhaus.org, reject_rhsbl_sender dbl.spamhaus.org, reject_unauth_destination";
            #  check_policy_service unix:private/policyd-spf,
            #  check_policy_service inet:127.0.0.1:10023

            # Milter configuration for opendkim and opendmarc
            milter_default_action = "accept";
            milter_protocol = "6";
            smtpd_milters =
              "local:opendkim/opendkim.sock,local:opendmarc/opendmarc.sock";
            non_smtpd_milters = "$smtpd_milters";
            # Postscreen
            postscreen_blacklist_action = "enforce";
            postscreen_access_list = "permit_mynetworks";
            postscreen_dnsbl_action = "enforce";
            postscreen_dnsbl_sites =
              "zen.spamhaus.org*3, bl.spameatingmonkey.net*2, bl.spamcop.net, dnsbl.sorbs.net, swl.spamhaus.org*-4, list.dnswl.org=127.[0..255].[0..255].0*-2, list.dnswl.org=127.[0..255].[0..255].1*-4, list.dnswl.org=127.[0..255].[0..255].[2..3]*-6";
            postscreen_greet_action = "enforce";
            postscreen_cache_map = "btree:${data_directory}/postscreen_cache";
            # 512MiB
            #message_size_limit = "536870900";
          };
          masterConfig = {
            smtp = {
              type = "inet";
              private = false;
              command = "postscreen";
              chroot = true;
              maxproc = 1;
            };
            smtpd = {
              type = "pass";
              chroot = true;
              args = [
                "-o"
                "smtpd_sender_restrictions=permit_mynetworks,reject_unknown_sender_domain,reject_unknown_reverse_client_hostname,reject_unknown_client_hostname"
                "-o"
                "smtpd_helo_required=yes"
                "-o"
                "smtpd_helo_restrictions=permit_mynetworks,reject_invalid_helo_hostname,reject_non_fqdn_helo_hostname,reject_unknown_helo_hostname"
              ];
            };
            dnsblog = {
              chroot = true;
              maxproc = 0;
            };
            tlsproxy = {
              chroot = true;
              maxproc = 0;
            };

          };
        };
    */
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${me.username} = {
    isNormalUser = true;
    createHome = true;
    home = "/home/${me.username}";
    description = me.name;
    extraGroups = [ "disk" "docker" "wheel" ];
    uid = 1000;
    shell = pkgs.zsh;
    hashedPassword =
      "$6$rJZSLnQH1hInB93$lfi4c2zxQbSJV7H9T9lrjOj6WIDhSEqP5FyjMinEE44j81E1l57hF6Epyxb02EbcWqDT9eYbyo4dBTAwewBgQ/";
  };
  users.mutableUsers = false;
  users.users."nginx".extraGroups = [ "acme" ];
  users.users."postfix".extraGroups = [ "acme" ];
  home-manager.users.${me.username} = import ./home-manager;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03";

  programs.ssh.startAgent = true;

  security = {
    sudo.wheelNeedsPassword = false;
    acme = {
      inherit (me) email;
      acceptTerms = true;
      certs =
        let credentialsFile = "/home/${me.username}/.config/lego/cloudflare";
        in {
          "${domain}" = {
            inherit (me) email;
            inherit dnsProvider credentialsFile;
          };
          "${domain}-wildcard" = {
            inherit (me) email;
            inherit dnsProvider credentialsFile;
            domain = subdomain "*";
          };
          "${alternateDomain}" = {
            inherit (me) email;
            inherit dnsProvider credentialsFile;
          };
          "${alternateDomain}-wildcard" = {
            inherit (me) email;
            inherit dnsProvider credentialsFile;
            domain = "*.${alternateDomain}";
          };
        };
    };
  };

  programs.zsh.enable = true;

  #virtualisation.docker.enable = true;
  #virtualisation.docker.enableOnBoot = true;

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
}

