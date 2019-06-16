require 'yaml'

use_inline_resources # ~FC113

def whyrun_supported?
  true
end


action :install do
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
  directory new_resource.local_storage_path do
    action :create
    recursive true
    mode '0755'
    owner "prometheus"
    group "prometheus"
  end
  arch = /x86_64/.match(node[:kernel][:machine]) ? 'amd64' : 'i686'
  remote_file "#{Chef::Config[:file_cache_path]}/prometheus-#{new_resource.version}.#{node['os']}_#{arch}.tar.gz" do
    source "#{new_resource.base_uri}v#{new_resource.version}/prometheus-#{new_resource.version}.#{node['os']}-#{arch}.tar.gz"
    checksum new_resource.checksum
    action :create_if_missing
  end
  execute "untar prometheus" do
    cwd "#{Chef::Config[:file_cache_path]}/"
    command "tar zxf prometheus-#{new_resource.version}.#{node['os']}_#{arch}.tar.gz"
    creates "#{Chef::Config[:file_cache_path]}/prometheus-#{new_resource.version}.#{node['os']}-#{arch}/prometheus"
  end
  execute "install prometheus binaries" do
    cwd "#{Chef::Config[:file_cache_path]}/prometheus-#{new_resource.version}.#{node['os']}-#{arch}"
    command "mv prom* /usr/bin"
    creates "/usr/bin/prometheus"
  end
  directory "/usr/share/doc/prometheus/examples" do
    action :create
    recursive true
    owner "prometheus"
    group "prometheus"
    mode '0755'
  end
  %w(LICENSE NOTICE).each do |p|
    execute "move document #{p}" do
      cwd "#{Chef::Config[:file_cache_path]}/prometheus-#{new_resource.version}.#{node['os']}-#{arch}"
      command "mv #{p} /usr/share/doc/prometheus/"
      action :run
      creates "/usr/share/doc/prometheus/#{p}"
    end
  end
  %w(consoles console_libraries).each do |p|
    execute "install #{p} examples" do
      cwd "#{Chef::Config[:file_cache_path]}/prometheus-#{new_resource.version}.#{node['os']}-#{arch}"
      command "mv #{p} /usr/share/doc/prometheus/examples"
      action :run
      creates "/usr/share/doc/prometheus/examples/#{p}"
    end
  end
end
      
action :start do
  template "/etc/default/prometheus" do
    source new_resource.template_name
    cookbook new_resource.cookbook
    owner 'prometheus'
    group 'prometheus'
    variables(
      :args => new_resource.arguments
    )
  end
  systemd_service 'prometheus' do
    unit do 
      description 'Prometheus Monitoring'
      documentation 'https://www.prometheus.io'
      after %w( multi-user.service )
    end
    service do
      type 'simple'
      exec_start '/usr/bin/prometheus $ARGS'
      exec_reload '/bin/kill -HUP $MAINPID'
      service_environment_file '/etc/default/prometheus'
      timeout_stop_sec '20s'
      send_sigkill false
    end
  end
end

action :config do
  directory "/etc/prometheus" do
    action :create
    recursive true
    owner "prometheus"
    group "prometheus"
  end
  config = Hash.new
  config['global']=JSON.parse(JSON.dump(new_resource.global || {}.to_hash))
  config['rule_files']=new_resource.rule_files unless new_resource.rule_files.empty?
  config['scrape_configs']=JSON.parse(JSON.dump(new_resource.scrape_configs || {}.to_hash))
  file "/etc/prometheus/prometheus.yml" do
    content YAML.dump(config, symbolize_names: false)
  end
  service "prometheus_service" do
    service_name "prometheus"
    action [:start,:enable]
    provider Chef::Provider::Service::Systemd
    subscribes :restart, "file[/etc/prometheus/prometheus.yml", :delayed
  end
end

