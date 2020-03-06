actions :create
default_action :create

# Version of prometheus to install
property :version, String, required: true
# Checksum of the prometheus tarball archive
property :checksum, String, required: true
# URI to the prometheus tarball archive
property :uri, String, required: true
# Prometheus home directory
property :home_dir, String, default: '/opt/prometheus', required: true
# Cookbook name that holds prometheus.erb
property :cookbook, String, default: 'prometheus', required: true
# Filename of the template to be used to create /etc/default/prometheus
property :template_name, String, default: "prometheus.erb", required: true
# Filename of the prometheus tarball archive
property :filename, String, required: true
# The path where the binaries are created after extracting the tarball
property :pathname, String, required: true
# The arguments passed to the prometheus server command line
property :arguments, Array, default: ['--config.file="/etc/prometheus/prometheus.yml"'], required: true
