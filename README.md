# MyFire

MyFire is really simple (and I mean really simple) firewall system for Linux machines. The firewall itself is based on ``iptables`` and ``ipset``. The default behavior of the firewall is to drop all incoming traffic except on port 22 (this is the default SSH port). The idea is to secure the system from the outer world and let the administrator does his job remotely via SSH.

One interesting MyFire feature is that it can protect your machine from blacklisted IP addresses reported by [badips.com](http://badips.com) and from [Tor](http://torproject.org) exit nodes.

Installation, setup and protection from potentially dangerous IPs is achieved with just 6 commands:

```
# Install the firewall
bash myfire-install.sh

# Initial firewall configuration
myfire-reset

# Protection from blacklisted IPs
myfire-download-badips
myfire-process badips

Protection from Tor exit nodes
myfire-download-torips
myfire-process torips
```

## Disclaimer

Don't blame MyFire or me personally if you get hacked. Your security is entirely your responsibility - always remember that!

## Installation

Download the scripts somewhere on your local machine and execute the following command:

```
bash myfire-install.sh
```

If you'd like, you can make the installer script executable and run it directly:

```
chmod +x myfire-install.sh
./myfire.install.sh
```

This is what happens when you run the installer:

* All scripts are installed in ``/opt/myfire``.
* Symbolic links ``myfire-*`` are created in ``/usr/sbin``.
* IP database files are created in ``/var/lib/myfire``.
* Log file ``/var/log/myfire.log`` is generated.

## Initial Setup

Now that you have installed MyFire, you can proceed with the initial firewall setup. Just execute the followin command:

```
myfire-reset
```

This is what happens when you execute the above command:

* **VERY IMPORTANT** - All existing ``iptables`` rules are discarded.
* New ``iptables`` rules are put in place and all incoming traffic is discarded except for traffic on port 22.

You can change the default behavior of the firewall reset functionality by editing the file ``/opt/myfire/myfire-reset.sh``. For example, you can allow more ports (e.g. 80 and 443 for http/https access). You can always use the ``iptables`` command to modify your firewall behavior after you perform the reset but the chances are that since you are reading this, most probably you are looking for fast and simple way to setup a basic firewall - hence the explanation where you should put your additional port configurations.

## Protection from bad IPs

MyFire can protect your machine from blacklisted IPs reported by [badips.com](http://badips.com). First we obtain the most recent blacklisted IPs:

```
myfire-download-badips
```

Then we load these IPs in MyFire:

```
myfire-process badips
```

Its convenient to repeat this process regularly, e.g. onece a day. You can schedule cron job for this process. Here is a sample ``crontab`` configuration:

```
35 1 * * * /bin/bash /opt/myfire/myfire-download-badips.sh >/dev/null 2>&1
45 1 * * * /bin/bash /opt/myfire/myfire-process.sh badips >/dev/null 2>&1
```

The above crontab configuration will trigger the download of blacklisted IPs at 01:35 AM and at 01:45 AM these IPs will be loaded in MyFire.

## Protection from Tor exit nodes

MyFire can protect your machine from Tor exit node IPs. This means that your machine will not be reachable through the Tor network 99% of the time (due to the dynamic nature of Tor there is never 100% guarantee) First we obtain the most re Tor exit node IPs:

```
myfire-download-torips
```

Then we load these IPs in MyFire:

```
myfire-process torips
```

Its convenient to repeat this process regularly, e.g. every two hours. You can schedule cron job for this process. Here is a sample ``crontab`` configuration:

```
19 */2 * * * /bin/bash /opt/myfire/myfire-download-torips.sh >/dev/null 2>&1
22 */2 * * * /bin/bash /opt/myfire/myfire-process.sh torips >/dev/null 2>&1
```

The above crontab configuration will trigger the download of blacklisted IPs every 2 hours at minute 19 and at minute 22 these IPs will be loaded in MyFire.

## MyFire blacklist functionality

MyFire allows you to maintain additional blacklist of IPs. This is useful if you want to protect your machine from specific IP address. Here is an example how to add IP address ``221.194.44.231`` to MyFire's blacklist:

```
myfire-black 221.194.44.231
```

The above command has immediate effect and the specified IP will no longer bother you.

## MyFire whitelist functionality

MyFire allows you to maintain additional whitelist of IPs. This is useful if you want to allow incoming traffic from specific IP address. The whitelist is processed before any firewall rules are applied, so be careful what IPs you add there. Here is an example how to add IP address `1.2.3.4` to the whitelist:

```
myfire-white 1.2.3.4
```
The above command has immediate effect and the specified IP will have access to all your open ports immediately.

## Important notes

By default neither ``iptables``, nor ``ipset`` persist their configurations. MyFire doesn't do that for you either. This means that even though you have MyFire up and running, once you restart your machine, all firewall rules will be lost. In this case you shoud setup MyFire again like this:

```
myfire-reset
myfire-process badips
myfire-process torips
myfire-process blackips
myfire-process whiteips
```

The ``myfire-process`` command loads the IP addresses for the respective service in the firewall:
* ``badips`` - IPs reported by [badips.com](http://badips.com).
* ``torips`` - Tor exit nodes.
* ``blackips`` - All IPs known to MyFire that have been provided via the ``myfire-black`` command.
* ``whiteips`` - All IPs known to MyFire that have been provided via the ``myfire-white`` command.

It's up to you to find appropriate persisting mechanism for your firewall. Both iptables and ipset provide such persistence functionality but the actual usage differs depending on your Linux distribution. If you do that, then obviously you don't need to go through the MyFire setup process after machine reboot.
