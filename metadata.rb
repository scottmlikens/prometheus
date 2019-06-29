name 'prometheus'
maintainer 'Scott M. Likens'
maintainer_email 'scott@likens.us'
license "Apache 2.0"
description 'Installs/Configures prometheus'
long_description 'Installs/Configures prometheus'
version '0.3.1'
chef_version '>= 12.14' if respond_to?(:chef_version)
depends "systemd"
issues_url 'https://github.com/damm/prometheus/issues'
source_url 'https://github.com/damm/prometheus'
