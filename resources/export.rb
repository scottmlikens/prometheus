actions :node,:mysql,:statsd

property :version, String, default: '0.18.1'
property :checksum, String, default: 'b2503fd932f85f4e5baf161268854bf5d22001869b84f00fd2d1f57b51b72424'
property :base_uri, String, default: 'https://github.com/prometheus/node_exporter/releases/download/v'
property :cookbook, String, default: 'prometheus'
property :template_name, String, default: "prometheus.erb"
property :arguments, Array, default: ['--collector.netstat.fields=(.*)','--collector.vmstat.fields=(.*)','--collector.interrupts','--collector.tcpstat']
property :home_dir, String, default: '/opt/prometheus'
property :dsn, String, default: 'root:root@(127.0.0.1:3306)/'
