name 'test_prom'
maintainer 'Scott M. Likens'
maintainer_email 'scott@likens.us'
license 'Apache 2.0'
description 'Installs/Configures test_prom'
long_description 'Installs/Configures test_prom'
version '0.1.0'
chef_version '>= 12.14' if respond_to?(:chef_version)
depends "prometheus"
