actions :install, :config, :start

property :version, String, default: '2.10.0'
property :checksum, String, default: 'f4233783826f18606b79e5cef0686e4a9c2030146a3c7ce134f0add09f5adcb7'
property :base_uri, String, default: 'https://github.com/prometheus/prometheus/releases/download/'
property :home_dir, String, default: '/opt/prometheus'
property :local_storage_path, String, default: '/var/lib/prometheus'
property :cookbook, String, default: 'prometheus'

# Config

property :global, Hash, default: { "global"=>{"scrape_interval"=>"15s", "evaluation_interval"=>"15s", "external_labels"=>{"monitor"=>"Chef"}}}
property :rule_files, Array, default: []

property :scrape_configs, Array, default: [{'job_name':"node", 'file_sd_configs':[{'files':["targets.json"]}]}]

property :arguments, Array, default: ['--config.file="/etc/prometheus/prometheus.yml"']
property :template_name, String, default: "prometheus.erb"
