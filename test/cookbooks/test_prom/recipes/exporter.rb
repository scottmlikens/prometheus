prometheus_exporter "node_exporter" do
  action :create
  checksum 'f175cffc4b96114e336288c9ea54b54abe793ae6fcbec771c81733ebc2d7be7c'
  uri 'https://github.com/prometheus/node_exporter/releases/download/v1.0.0-rc.0/node_exporter-1.0.0-rc.0.linux-amd64.tar.gz'
  filename 'node-exporter-1.0.0-rc.0.linux-amd64.tar.gz'
  pathname 'node_exporter-1.0.0-rc.0.linux-amd64'
  binaries ['node_exporter']
  start_command 'node_exporter'
end
