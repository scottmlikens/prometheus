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
  arch = /x86_64/.match(node[:kernel][:machine]) ? 'amd64' : 'i686'
  remote_file "#{Chef::Config[:file_cache_path]}/alertmanager-#{new_resource.version}.#{node['os']}_#{arch}.tar.gz" do
    source "#{new_resource.base_uri}v#{new_resource.version}/alertmanager-#{new_resource.version}.#{node['os']}-#{arch}.tar.gz"
    checksum new_resource.checksum
    action :create_if_missing
  end
  execute "untar alertmanager" do
    cwd "#{Chef::Config[:file_cache_path]}/"
    command "tar zxf alertmanager-#{new_resource.version}.#{node['os']}_#{arch}.tar.gz"
    creates "#{Chef::Config[:file_cache_path]}/alertmanager-#{new_resource.version}.#{node['os']}-#{arch}/alertmanager"
  end
  execute "install alertmanager binaries" do
    cwd "#{Chef::Config[:file_cache_path]}/alertmanager-#{new_resource.version}.#{node['os']}-#{arch}"
    command "mv alertmanager /usr/bin && mv amtool /usr/bin"
    creates "/usr/bin/alertmanager"
  end
end

action :start do
  template "/etc/default/alertmanager" do
    source new_resource.template_name
    cookbook new_resource.cookbook
    owner 'prometheus'
    group 'prometheus'
    variables(
      :args => new_resource.arguments
    )
  end
  systemd_service 'alertmanager' do
    unit do
      description 'Alertmanager for Prometheus Monitoring'
      documentation 'https://www.prometheus.io'
      after %w( multi-user.service )
    end
    service do
      type 'simple'
      exec_start '/usr/bin/alertmanager $ARGS'
      exec_reload '/bin/kill -HUP $MAINPID'
      service_environment_file '/etc/default/alertmanager'
      timeout_stop_sec '20s'
      send_sigkill false
    end
  end
  service "alertmanager" do
    action [:start,:enable]
  end
end
