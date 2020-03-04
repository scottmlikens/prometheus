action :create do
  user 'prometheus' do
    system true
    shell '/bin/false'
    home new_resource.home_dir
  end
  directory new_resource.home_dir do
    action :create
    recursive true
    mode 0755
    owner 'prometheus'
    group 'prometheus'
  end
  directory new_resource.home_dir + '/bin' do
    action :create
    recursive true
    mode 0755
    owner 'prometheus'
    group 'prometheus'
  end
  remote_file Chef::Config[:file_cache_path] + '/' + new_resource.filename do
    source new_resource.uri
    checksum new_resource.checksum
    action :create_if_missing
  end
  execute 'extract ' + new_resource.name do
    cwd "#{Chef::Config[:file_cache_path]}/"
    command 'tar zxf ' + new_resource.filename
    creates Chef::Config[:file_cache_path] + '/' + new_resource.pathname + '/README.md'
  end
  if new_resource.binaries.empty?
    raise "binaries array is unset cannot proceed"
  else
    new_resource.binaries.each do |p|
      execute "install #{p}" do
        cwd Chef::Config[:file_cache_path] + '/' + new_resource.pathname
        command 'cp ' + p + ' ' + new_resource.home_dir + '/bin'
        creates '/opt/prometheus/bin/' + p
      end
    end
  end
  template '/etc/default/prometheus-' + new_resource.name do
    source new_resource.template_name
    cookbook new_resource.cookbook
    owner 'prometheus'
    group 'prometheus'
    variables(
      :args => new_resource.arguments,
      :dsn => new_resource.dsn
    )
  end
  if new_resource.start_command   
    systemd_service 'prometheus-' + new_resource.name do
      unit do
        description new_resource.name
        after %w( networking.service  )
      end
      install do
        wanted_by %w( multi-user.target )
      end
      service do
        type 'simple'
        exec_start new_resource.home_dir + '/bin/' + new_resource.start_command + ' $ARGS'
        exec_reload '/bin/kill -HUP $MAINPID'
        service_environment_file '/etc/default/prometheus-' + new_resource.name
        timeout_stop_sec '20s'
        #      verify false
      end
    end
    service 'prometheus-' + new_resource.name do
      action [:start,:enable]
      provider Chef::Provider::Service::Systemd
      subscribes :restart, 'template[/etc/default/prometheus-' + new_resource.name + ']', :delayed
    end
  else
    raise "no start_command given"
  end
end
