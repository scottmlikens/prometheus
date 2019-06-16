action :install do
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
end
