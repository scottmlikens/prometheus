directory "/etc/prometheus" do
  action :create
end
cookbook_file "/etc/prometheus/prometheus.yml" do
  source "prometheus.yml"
end
cookbook_file '/etc/prometheus/rules1.rules' do
  source 'rules1.rules'
end
prometheus_monitor "default" do
  version "2.16.0"
  action :install
  uri 'https://github.com/prometheus/prometheus/releases/download/v2.16.0/prometheus-2.16.0.linux-amd64.tar.gz'
  checksum 'c04e631d18e186b66a51cac3062157298e037ffae784f35ccaaf29e496d65d3f'
  filename 'prometheus-2.16.0.linux-amd64.tar.gz'
  pathname 'prometheus-2.16.0.linux-amd64'
  arguments ["--config.file='/etc/prometheus/prometheus.yml'","--storage.tsdb.retention=30d"]
  action [:install,:start]
end
