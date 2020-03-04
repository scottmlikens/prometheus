actions :install, :config, :start

property :version, String
property :checksum, String
property :uri, String
property :home_dir, String, default: '/opt/prometheus'
property :local_storage_path, String, default: '/var/lib/prometheus'
property :cookbook, String, default: 'prometheus'
property :filename, String
property :pathname, String

# Config

property :global, Hash, default: { "global"=>{"scrape_interval"=>"15s", "evaluation_interval"=>"15s", "external_labels"=>{"monitor"=>"Chef"}}}
property :rule_files, Array, default: []

property :scrape_configs, Array, default: [{'job_name':"node", 'file_sd_configs':[{'files':["targets.json"]}]}]

property :arguments, Array, default: ['--config.file="/etc/prometheus/prometheus.yml"']
property :template_name, String, default: "prometheus.erb"
