actions :install, :start

property :version, String, default: '0.18.0'
property :checksum, String, default: '5f17155d669a8d2243b0d179fa46e609e0566876afd0afb09311a8bc7987ab15'
property :uri, String
property :home_dir, String, default: '/opt/prometheus'
property :cookbook, String, default: 'prometheus'
property :filename, String
property :pathname, String


property :arguments, Array, default: ['--config.file="/etc/prometheus/alertmanager.yml"']
property :template_name, String, default: "prometheus.erb"
