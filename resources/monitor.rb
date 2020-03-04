actions :install, :start

property :version, String
property :checksum, String
property :uri, String
property :home_dir, String, default: '/opt/prometheus'
property :local_storage_path, String, default: '/var/lib/prometheus'
property :cookbook, String, default: 'prometheus'
property :filename, String
property :pathname, String
property :arguments, Array, default: ['--config.file="/etc/prometheus/prometheus.yml"']
property :template_name, String, default: "prometheus.erb"
