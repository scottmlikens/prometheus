actions :create

property :checksum, String
property :uri, String
property :filename, String
property :pathname, String
property :cookbook, String, default: 'prometheus'
property :template_name, String, default: "prometheus.erb"
property :arguments, Array, default: []
property :home_dir, String, default: '/opt/prometheus'
property :binaries, Array, default: []
property :start_command, String
property :dsn
