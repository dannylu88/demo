#cloud-config
repo_update: true
repo_upgrade: all
packages:
 - htop
 - language-pack-en 
 - python
 - curl
 - libcurl4-openssl-dev
 - libssl-dev
 - libyaml-dev
 - libreadline6-dev
 - zlib1g-dev
 - libncurses5-dev
 - ntp
 - aptitude
 - default-jdk
runcmd:
 - locale-gen en_GB.UTF-8
 - update-locale LANGUAGE=en_GB.UTF-8 LANG=en_GB.UTF-8 LC_ALL=en_GB.UTF-8
 - dpkg-reconfigure --frontend noninteractive tzdata
 - [ sh, -c, "chmod -R 755 /home/ubuntu" ]
 - [ sh, -c, "chmod 775 /var/log" ]
 - [ sh, -c, "chmod -R 770 /var/log/nginx" ]
 - [ sh, -c, "chmod -R 770 /var/log/cloud-init.log" ]
 - [ sh, -c, "chmod -R 770 /var/log/alternatives.log" ]
 - [ sh, -c, "chmod -R 770 /var/log/wtmp" ]
 - [ sh, -c, "chmod -R 770 /var/log/apt/history.log" ]
 - [ sh, -c, "chmod -R 770 /var/log/unattended-upgrades" ]
 - [ sh, -c, "addr=`ip route get 8.8.8.8 | awk '{print $NF; exit}'`;echo $addr ${hostname} >> /etc/hosts" ]
 - [ sh, -c, "echo ${hostname} > /etc/hostname" ]
 - [ sh, -c, "hostname ${hostname}" ]
 - [ sh, -c, "apt-get -y purge unattended-upgrades"]
 - [ sh, -c, "sudo useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat"]
 - [ sh, -c, "wget -c https://downloads.apache.org/tomcat/tomcat-9/v9.0.34/bin/apache-tomcat-9.0.34.tar.gz"]
 - [ sh, -c, "sudo ln -s /opt/tomcat/apache-tomcat-9.0.34 /opt/tomcat/updated"]
 - [ sh, -c, "sudo chown -R tomcat: /opt/tomcat/*"]
 - [ sh, -c, "sudo chmod +x /opt/tomcat/updated/bin/*.sh"]
 - [ sh, -c, "sudo systemctl daemon-reload"]
 - [ sh, -c, "sudo systemctl start tomcat"]
 - [ sh, -c, "sudo systemctl enable tomcat"]
 - [ sh, -c, "sudo ufw allow 8080/tcp"]

write_files:
  - path: /etc/ntp.conf
    permissions: 0644
    owner: root
    content: |
        driftfile /var/lib/ntp/ntp.drift
        disable monitor
        # Enable this if you want statistics to be logged.
        #statsdir /var/log/ntpstats/

        statistics loopstats peerstats clockstats
        filegen loopstats file loopstats type day enable
        filegen peerstats file peerstats type day enable
        filegen clockstats file clockstats type day enable

        # Specify one or more NTP servers.

        # Use servers from the NTP Pool Project. Approved by Ubuntu Technical Board
        # on 2011-02-08 (LP: #104525). See http://www.pool.ntp.org/join.html for
        # more information.
        server 169.254.169.123 prefer iburst

        # By default, exchange time with everybody, but don't allow configuration.
        restrict default kod notrap nomodify nopeer noquery

        restrict 10.211.0.0 mask 255.255.240.0 nomodify notrap

        # Local users may interrogate the ntp server more closely.
        restrict 127.0.0.1
        restrict ::1

        #Local Clock backup
        server  127.127.1.0
        fudge   127.127.1.0 stratum 10
  - path: /etc/profile.d/global_variables.sh
    permissions: 0644
    owner: root
    content: |
                export no_proxy=localhost,127.0.0.1,169.254.169.254
  - path: /etc/rc.local
    permissions: 0644
    owner: root
    content: |
        #!/bin/sh -e
        #
        # rc.local
        #
        # This script is executed at the end of each multiuser runlevel.
        # Make sure that the script will "exit 0" on success or any other
        # value on error.
        #
        # In order to enable or disable this script just change the execution
        # bits.
        #
        # By default this script does nothing.
        sudo -E /usr/sbin/update_hosts.sh
        exit 0
  - path: /etc/issue
    permissions: 0640
    owner: root
    content: |
         *********************************************************************
                     WARNING - COMPUTER MISUSE ACT 1990
                  YOU WILL COMMIT A CRIMINAL OFFENCE IF YOU ACT
                OUTSIDE YOUR AUTHORITY IN RELATION TO THIS COMPUTER.
                            THE PENALTY IS
                     A FINE, IMPRISONMENT, OR BOTH.
                 IF YOU ARE ACTING OUTSIDE YOUR AUTHORITY,
                       DO NOT PROCEED ANY FURTHER.
         *********************************************************************
  - path: /etc/motd
    permissions: 0640
    owner: root
    content: |
         *********************************************************************
                     WARNING - COMPUTER MISUSE ACT 1990
                  YOU WILL COMMIT A CRIMINAL OFFENCE IF YOU ACT
                OUTSIDE YOUR AUTHORITY IN RELATION TO THIS COMPUTER.
                              THE PENALTY IS
                       A FINE, IMPRISONMENT, OR BOTH.
                   IF YOU ARE ACTING OUTSIDE YOUR AUTHORITY,
                         DO NOT PROCEED ANY FURTHER.
         *********************************************************************
  - path: /etc/securetty
    permissions: 0640
    owner: root
    content: |
         # /etc/securetty: list of terminals on which root is allowed to login.
         # See securetty(5) and login(1).
         console
         # Local X displays (allows empty passwords with pam_unix's nullok_secure)
         # ==========================================================
         #
         # TTYs sorted by major number according to Documentation/devices.txt
         #
         # ==========================================================
         # Virtual consoles
         tty1
         tty2
         tty3
         tty4
  - path: /etc/sysctl.conf
    permissions: 0640
    owner: root
    content: |
        net.ipv4.conf.all.accept_source_route = 0
        net.ipv4.conf.default.accept_source_route = 0
        net.ipv4.conf.all.accept_redirects = 0
        net.ipv4.conf.default.accept_redirects = 0
        net.ipv4.conf.all.secure_redirects = 0
        net.ipv4.conf.default.secure_redirects = 0
        net.ipv4.conf.all.log_martians = 1
        net.ipv4.conf.default.log_martians = 1
        net.ipv4.icmp_echo_ignore_broadcasts = 1
        net.ipv4.icmp_ignore_bogus_error_responses = 1
        net.ipv4.conf.all.rp_filter = 1
        net.ipv4.conf.default.rp_filter = 1
        net.ipv4.tcp_syncookies = 1
        net.ipv4.tcp_max_syn_backlog = 4096
        net.ipv4.ip_forward = 0
  - path: /etc/timezone
    permissions: 0644
    owner: root
    content: |
         Europe/London
  - path: /etc/cron.allow
    permissions: 0644
    owner: root
    content: |
         ubuntu
         root
  - path: /etc/systemd/system/tomcat.service
    permissions: 0640
    owner: tomcat
    content: |
        [Unit]
        Description=Apache Tomcat Web Application Container
        After=network.target

        [Service]
        Type=forking

        Environment="JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64"
        Environment="CATALINA_PID=/opt/tomcat/updated/temp/tomcat.pid"
        Environment="CATALINA_HOME=/opt/tomcat/updated/"
        Environment="CATALINA_BASE=/opt/tomcat/updated/"
        Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
        Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

        ExecStart=/opt/tomcat/updated/bin/startup.sh
        ExecStop=/opt/tomcat/updated/bin/shutdown.sh

        User=tomcat
        Group=tomcat
        UMask=0007
        RestartSec=10
        Restart=always

        [Install]
        WantedBy=multi-user.target