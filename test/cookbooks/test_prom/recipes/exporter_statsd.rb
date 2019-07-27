prometheus_export "statsd" do
  action :statsd
  checksum '9976810ae7a0e3593d6727d46d8c45a23f534e5794de816ed8309a42bb86cb34'
  arguments ['--statsd.listen-unixgram=/tmp/statsd.sock']
  base_uri 'https://github.com/prometheus/statsd_exporter/releases/download/v'
  version '0.12.2'
end
