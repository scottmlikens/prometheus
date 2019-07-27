action :node do
  user "prometheus" do
    system true
    shell '/bin/false'
    home new_resource.home_dir
  end
  directory new_resource.home_dir do
    action :create
    recursive true
    mode '0755'
    owner "prometheus"
    group "prometheus"
  end
  arch = /x86_64/.match(node[:kernel][:machine]) ? 'amd64' : 'i686'
  remote_file "#{Chef::Config[:file_cache_path]}/node_exporter-#{new_resource.version}.#{node['os']}-#{arch}.tar.gz" do
    source "#{new_resource.base_uri}#{new_resource.version}/node_exporter-#{new_resource.version}.#{node['os']}-#{arch}.tar.gz"
    checksum new_resource.checksum
    action :create_if_missing
  end
  execute "untar node exporter" do
    cwd "#{Chef::Config[:file_cache_path]}/"
    command "tar zxf node_exporter-#{new_resource.version}.#{node['os']}-#{arch}.tar.gz"
    creates "#{Chef::Config[:file_cache_path]}/node_exporter-#{new_resource.version}.#{node['os']}-#{arch}/node_exporter"
  end
  execute "install node exporter binaries" do
    cwd "#{Chef::Config[:file_cache_path]}/node_exporter-#{new_resource.version}.#{node['os']}-#{arch}/"
    command "mv node_exporter /usr/bin"
    creates "/usr/bin/node_exporter"
  end
  template "/etc/default/prometheus-node-exporter" do
    source new_resource.template_name
    cookbook new_resource.cookbook
    owner 'prometheus'
    group 'prometheus'
    variables(
      :args => new_resource.arguments
    )
  end
  case node['platform_version']
  when '14.04'
    template "/etc/init/prometheus-node-exporter.conf" do
      source "prometheus_node_exporter.conf.erb"
      cookbook "prometheus"
    end
    service "prometheus-node_exporter_upstart" do
      service_name "prometheus-node-exporter"
      action [:start,:enable]
      provider Chef::Provider::Service::Upstart
    end
  else
    systemd_service 'prometheus-node-exporter' do
      unit do
        description 'Node Exporter'
        documentation 'https://www.prometheus.io'
        after %w( networking.service  )
      end
      install do
        wanted_by %w( multi-user.target )
      end
      service do
        type 'simple'
        exec_start '/usr/bin/node_exporter $ARGS'
        exec_reload '/bin/kill -HUP $MAINPID'
        service_environment_file '/etc/default/prometheus-node-exporter'
        timeout_stop_sec '20s'
      end
    end
    service "prometheus-node-exporter" do
      action [:start,:enable]
      provider Chef::Provider::Service::Systemd
      subscribes :restart, "template[/etc/default/prometheus-node-exporter]", :delayed
    end
  end
end

action :mysql do
  user "prometheus" do
    system true
    shell '/bin/false'
    home new_resource.home_dir
  end
  directory new_resource.home_dir do
    action :create
    recursive true
    mode '0755'
    owner "prometheus"
    group "prometheus"
  end
  arch = /x86_64/.match(node[:kernel][:machine]) ? 'amd64' : 'i686'
  remote_file "#{Chef::Config[:file_cache_path]}/mysqld_exporter-#{new_resource.version}.#{node['os']}-#{arch}.tar.gz" do
    source "#{new_resource.base_uri}#{new_resource.version}/mysqld_exporter-#{new_resource.version}.#{node['os']}-#{arch}.tar.gz"
    checksum new_resource.checksum
    action :create_if_missing
  end
  execute "untar mysqld exporter" do
    cwd "#{Chef::Config[:file_cache_path]}/"
    command "tar zxf mysqld_exporter-#{new_resource.version}.#{node['os']}-#{arch}.tar.gz"
    creates "#{Chef::Config[:file_cache_path]}/mysqld_exporter-#{new_resource.version}.#{node['os']}-#{arch}/mysqld_exporter"
  end
  execute "install mysqld exporter binaries" do
    cwd "#{Chef::Config[:file_cache_path]}/mysqld_exporter-#{new_resource.version}.#{node['os']}-#{arch}/"
    command "mv mysqld_exporter /usr/bin"
    creates "/usr/bin/mysqld_exporter"
  end
  template "/etc/default/prometheus-mysqld-exporter" do
    source new_resource.template_name
    cookbook new_resource.cookbook
    owner 'prometheus'
    group 'prometheus'
    variables(
      :dsn => new_resource.dsn,
      :args => new_resource.arguments
    )
  end
  systemd_service 'prometheus-mysqld-exporter' do
    unit do
      description 'MySQLd Exporter'
      documentation 'https://www.prometheus.io'
      after %w( networking.service  )
    end
    install do
      wanted_by %w( multi-user.target )
    end
    service do
      type 'simple'
      exec_start '/usr/bin/mysqld_exporter $ARGS'
      exec_reload '/bin/kill -HUP $MAINPID'
      service_environment_file '/etc/default/prometheus-mysqld-exporter'
      timeout_stop_sec '20s'
    end
  end
  service "prometheus-mysqld-exporter" do
    action [:start,:enable]
    provider Chef::Provider::Service::Systemd
    subscribes :restart, "template[/etc/default/prometheus-mysqld-exporter]", :delayed
  end
end

##

action :statsd do
  user "prometheus" do
    system true
    shell '/bin/false'
    home new_resource.home_dir
  end
  directory new_resource.home_dir do
    action :create
    recursive true
    mode '0755'
    owner "prometheus"
    group "prometheus"
  end
  arch = /x86_64/.match(node[:kernel][:machine]) ? 'amd64' : 'i686'
  remote_file "#{Chef::Config[:file_cache_path]}/statsd_exporter-#{new_resource.version}.#{node['os']}-#{arch}.tar.gz" do
    source "#{new_resource.base_uri}#{new_resource.version}/statsd_exporter-#{new_resource.version}.#{node['os']}-#{arch}.tar.gz"
    checksum new_resource.checksum
    action :create_if_missing
  end
  execute "untar statsd exporter" do
    cwd "#{Chef::Config[:file_cache_path]}/"
    command "tar zxf statsd_exporter-#{new_resource.version}.#{node['os']}-#{arch}.tar.gz"
    creates "#{Chef::Config[:file_cache_path]}/statsd_exporter-#{new_resource.version}.#{node['os']}-#{arch}/statsd_exporter"
  end
  execute "install statsd exporter binaries" do
    cwd "#{Chef::Config[:file_cache_path]}/statsd_exporter-#{new_resource.version}.#{node['os']}-#{arch}/"
    command "mv statsd_exporter /usr/bin"
    creates "/usr/bin/statsd_exporter"
  end
  case node['platform_version']
  when '14.04'
    template "/etc/init/prometheus-statsd-exporter.conf" do
      source "prometheus_statsd_exporter.conf.erb"
      cookbook "prometheus"
    end
    service "prometheus-statsd_exporter_upstart" do
      service_name "prometheus-statsd-exporter"
      action [:start,:enable]
      provider Chef::Provider::Service::Upstart
    end
    
  else
    template "/etc/default/prometheus-statsd-exporter" do
      source new_resource.template_name
      cookbook new_resource.cookbook
      owner 'prometheus'
      group 'prometheus'
      variables(
        :args => new_resource.arguments
      )
    end
    systemd_service 'prometheus-statsd-exporter' do
      unit do
        description 'StatsD Exporter'
        documentation 'https://www.prometheus.io'
        after %w( networking.service  )
      end
      install do
        wanted_by %w( multi-user.target )
      end
      service do
        type 'simple'
        exec_start '/usr/bin/statsd_exporter $ARGS'
        exec_reload '/bin/kill -HUP $MAINPID'
        service_environment_file '/etc/default/prometheus-statsd-exporter'
        timeout_stop_sec '20s'
      end
    end
    service "prometheus-statsd-exporter" do
      action [:start,:enable]
      provider Chef::Provider::Service::Systemd
      subscribes :restart, "template[/etc/default/prometheus-statsd-exporter]", :delayed
    end
  end
end
