actions :install, :start

property :version, String, default: '0.18.0'
property :checksum, String, default: '5f17155d669a8d2243b0d179fa46e609e0566876afd0afb09311a8bc7987ab15'
property :base_uri, String, default: 'https://github.com/prometheus/alertmanager/releases/download/'
property :home_dir, String, default: '/opt/prometheus'
property :cookbook, String, default: 'prometheus'


property :arguments, Array, default: ['--config.file="/etc/prometheus/alertmanager.yml"']
property :template_name, String, default: "prometheus.erb"
