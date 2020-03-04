cookbook_file "/etc/prometheus/alertmanager.yml" do
  owner "prometheus"
  group "prometheus"
end
prometheus_alertmanager "Test Kitchen" do
  action [:install,:start]
  version '0.20.0'
  uri 'https://github.com/prometheus/alertmanager/releases/download/v0.20.0/alertmanager-0.20.0.linux-amd64.tar.gz'
  checksum '3a826321ee90a5071abf7ba199ac86f77887b7a4daa8761400310b4191ab2819'
  filename 'alertmanager-0.20.0.linux-amd64.tar.gz'
  pathname 'alertmanager-0.20.0.linux-amd64'
end
