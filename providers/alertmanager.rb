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
  directory new_resource.home_dir + '/bin' do
    action :create
    owner 'prometheus'
    group 'prometheus'
    mode 0755
  end
  remote_file Chef::Config[:file_cache_path] + '/' + new_resource.filename do
    source new_resource.uri
    checksum new_resource.checksum
    action :create_if_missing
  end
  execute "untar alertmanager" do
    cwd Chef::Config[:file_cache_path]
    command 'tar zxf ' + new_resource.filename
    creates Chef::Config[:file_cache_path] + '/' + new_resource.pathname + '/alertmanager'
  end
  ["alertmanager","amtool"].each do |p|
    execute 'install ' + p + 'binaries' do
      cwd Chef::Config[:file_cache_path] + '/' + new_resource.pathname
      command 'cp ' + p + ' /opt/prometheus/bin/' + p + '-' + new_resource.version
      creates '/opt/prometheus/bin/' + p + '-' + new_resource.version
    end
  end
end

action :start do
  template '/etc/default/alertmanager' do
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
      exec_start '/opt/prometheus/bin/alertmanager-' + new_resource.version + ' $ARGS'
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
