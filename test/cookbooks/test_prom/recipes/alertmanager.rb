prometheus_monitor "default" do
  version "2.10.0"
  action :install
end
global_config={"scrape_interval"=>"15s", "evaluation_interval"=>"15s", "external_labels"=>{"monitor"=>"Test Kitchen"}}
prometheus_monitor "start" do
  arguments ["--config.file='/etc/prometheus/prometheus.yml'","--storage.tsdb.retention=30d"]
  action :start
end
prometheus_monitor "config" do
  global global_config
  rule_files ["rules1.rules"]
  action :config
end
cookbook_file "/etc/prometheus/alertmanager.yml" do
  owner "prometheus"
  group "prometheus"
end
prometheus_alertmanager "default" do
  action :install
  version "0.18.0"
end
prometheus_alertmanager "start" do
  action :start
end
