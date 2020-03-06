prometheus_exporter "statsd_exporter" do
  action :create
  checksum 'c9e685db2558b96d40bb60c36420054457421fce8c6aad4b7fa14d9cff0ff04d'
  arguments ['--statsd.listen-unixgram=/tmp/statsd.sock']
  uri 'https://github.com/prometheus/statsd_exporter/releases/download/v0.14.1/statsd_exporter-0.14.1.linux-amd64.tar.gz'
  filename 'statsd_exporter-0.14.1.linux-amd64.tar.gz'
  pathname 'statsd_exporter-0.14.1.linux-amd64'
  binaries ['statsd_exporter']
  start_command 'statsd_exporter'
end
