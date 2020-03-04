prometheus_exporter 'mysqld_exporter' do
  action :create
  uri 'https://github.com/prometheus/mysqld_exporter/releases/download/v0.12.1/mysqld_exporter-0.12.1.linux-amd64.tar.gz'
  checksum '133b0c281e5c6f8a34076b69ade64ab6cac7298507d35b96808234c4aa26b351'
  filename 'mysqld_exporter-0.12.1.linux-amd64.tar.gz'
  pathname 'mysqld_exporter-0.12.1.linux-amd64'
  binaries ['mysqld_exporter']
  start_command "mysqld_exporter"
  dsn 'root:root@(127.0.0.1:3306)/'
  arguments ['--collect.engine_innodb_status','--collect.slave_status']
end
