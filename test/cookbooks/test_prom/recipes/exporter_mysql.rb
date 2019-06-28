prometheus_export "mysql" do
  action :mysql
  dsn 'root:root@(127.0.0.1:3306)/'
  checksum 'b53ad48ff14aa891eb6a959730ffc626db98160d140d9a66377394714c563acf'
  arguments ['--collect.engine_innodb_status','--collect.slave_status']
  base_uri 'https://github.com/prometheus/mysqld_exporter/releases/download/v'
  version '0.11.0'
end
