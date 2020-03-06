control 'mysqld exporter should be installed' do
  describe file('/opt/prometheus//bin/mysqld_exporter') do
    it { should be_file }
    it { should be_executable }
  end
end
control 'it should be running under systemd' do
  describe file('/etc/systemd/system/prometheus-mysqld_exporter.service') do
    it { should be_file }
    its(:content) { should match /MAINPID/ }
  end
  describe file('/etc/default/prometheus-mysqld_exporter') do
    it { should be_file }
    its(:content) { should match /ARGS/ }
    its(:content) { should match /DATA_SOURCE_NAME/ }
  end
end
