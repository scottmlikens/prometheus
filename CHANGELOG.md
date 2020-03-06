# prometheus CHANGELOG

# 1.0.0

Drop Ubuntu 14.04 support
Remove export.rb resource and provider in favor of an single action resource and provider
Move installation of exporters to `/opt/prometheus`
Move installation of prometheus to `/opt/prometheus` and version the binaries to ease upgrade pain
Same with alertmanager
Move prometheus and exporters to be run under the `ubuntu` user
Add restarts to a service to ensure prometheus restarts if you change the command line arguments
Abandon `:install` and `:start` actions in favor of a simple `:create` action

# 0.4.4

Make node exporter ignore veth and docker0 and lo by default

# 0.4.3

Make statsd exporter support ubuntu 14.04

# 0.4.2

Add statsd exporter

# 0.4.1

Make it so node exporter and mysql start on reboot
Add --collector.tcpstat to the argument list by default

# 0.4.0

Add alertmanager

# 0.3.3

Started in Vagrant once failed further without the quotes around the ()'s 
# 0.3.2

Add 14.04 support for node exporter

# 0.3.1

Bugfix in template


# 0.3.0

Add mysqld_exporter installation

# 0.2.0

Added node export installation

# 0.1.0

Initial release.
