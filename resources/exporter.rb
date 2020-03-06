actions :create
default_action :create

# Checksum of the exporter archive
property :checksum, String, required: true
# URI to the exporter tarball archive
property :uri, String, required: true
# Filename of the exporter tarball archive
property :filename, String, required: true
# The path where the binaries are created after extracting the tarball
property :pathname, String, required: true
# Cookbook name that holds prometheus.erb
property :cookbook, String, default: 'prometheus', required: true
# Filename of the template used to create /etc/default/prometheus-<exportername>
property :template_name, String, default: "prometheus.erb", required: true
# Arguments to be passed to the exporter
property :arguments, Array, default: [], required: false
# Prometheus home directory
property :home_dir, String, default: '/opt/prometheus', required: true
# List of binaries to copy from archive for exporter to function
property :binaries, Array, default: [], required: true
# The command to start the exporter
property :start_command, String, required: true
# If using the mysql exporter this lets you set the DSN easily
property :dsn, String, required: false
