actions :create
default_action :create

# Version of alertmanager to install
property :version, String, required: true
# Checksum of the alertmanager tarball
property :checksum, String, required: true
# URI to the alertmanager tarball archive
property :uri, String, required: true
# Prometheus home directory
property :home_dir, String, default: '/opt/prometheus', required: true
# Cookbook name that holds prometheus.erb
property :cookbook, String, default: 'prometheus', required: true
# Filename of the template used to create /etc/default/alertmanager
property :template_name, String, default: "prometheus.erb", required: true
# Filename of the alertmanager tarball archive
property :filename, String, required: true
# The path where the binaries are created after extracting the tarball
property :pathname, String, required: true
# arguments passed to start alertmanager on the command line
property :arguments, Array, default: ['--config.file="/etc/prometheus/alertmanager.yml"'], required: true
