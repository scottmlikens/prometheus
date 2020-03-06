require 'yaml'

use_inline_resources # ~FC113

def whyrun_supported?
  true
end


action :create do
  user 'prometheus' do
    system true
    shell '/bin/false'
    home new_resource.home_dir
  end
  directory new_resource.home_dir do
    action :create
    recursive true
    mode '0755'
    owner 'prometheus'
    group 'prometheus'
  end
  directory new_resource.home_dir + '/bin' do
    action :create
    recursive true
    mode '0755'
    owner 'prometheus'
    group 'prometheus'
  end
  directory '/var/lib/prometheus' do
    action :create
    recursive true
    mode '0755'
    owner 'prometheus'
    group 'prometheus'
  end
  remote_file Chef::Config[:file_cache_path] + '/' + new_resource.filename do
    source new_resource.uri
    checksum new_resource.checksum
    action :create_if_missing
  end
  execute 'untar prometheus' do
    cwd Chef::Config[:file_cache_path] + '/'
    command 'tar zxf ' + new_resource.filename
    creates Chef::Config[:file_cache_path] + '/' + new_resource.pathname + '/prometheus'
  end
  %w(promtool prometheus).each do |p|
    execute 'install ' + p + 'binaries' do
      cwd Chef::Config[:file_cache_path] + '/' + new_resource.pathname
      command 'cp ' + p + ' ' + new_resource.home_dir + '/bin/' + p + '-' + new_resource.version
      creates new_resource.home_dir + '/bin/' + p + '-' + new_resource.version
    end
  end
  directory '/usr/share/doc/prometheus/examples' do
    action :create
    recursive true
    owner 'prometheus'
    group 'prometheus'
    mode '0755'
  end
  %w(LICENSE NOTICE).each do |p|
    execute 'move document ' + p do
      cwd Chef::Config[:file_cache_path] + '/' + new_resource.pathname
      command 'cp ' + p  + ' /usr/share/doc/prometheus/'
      action :run
      creates '/usr/share/doc/prometheus/' + p
    end
  end
  %w(consoles console_libraries).each do |p|
    execute 'install ' + p + 'examples' do
      cwd Chef::Config[:file_cache_path] + '/' + new_resource.pathname
      command 'cp -r ' + p + ' /usr/share/doc/prometheus/examples'
      action :run
      creates '/usr/share/doc/prometheus/examples/' + p
    end
  end
  template '/etc/default/prometheus' do
    source new_resource.template_name
    cookbook new_resource.cookbook
    owner 'prometheus'
    group 'prometheus'
    variables(
      args: new_resource.arguments
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
      user 'prometheus'
      group 'prometheus'
      exec_start '/opt/prometheus/bin/prometheus-' + new_resource.version + ' $ARGS'
      exec_reload '/bin/kill -HUP $MAINPID'
      service_environment_file '/etc/default/prometheus'
      timeout_stop_sec '20s'
      send_sigkill false
    end
  end
  service 'prometheus_nothing' do
    service_name 'prometheus'
    action :nothing
    subscribes :restart, 'template[/etc/default/prometheus]',:delayed
    subscribes :restart, 'systemd_service[/etc/systemd/system/prometheus.yml]',:delayed
  end
end
