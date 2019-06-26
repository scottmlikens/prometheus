control 'node exporter should be installed' do
  describe file('/usr/bin/node_exporter') do
    it { should be_file }
    it { should be_executable }
  end
end
control 'it should be running under ssystemd' do
  describe file('/etc/systemd/system/prometheus-node-exporter.service') do
    it { should be_file }
    its(:content) { should match /MAINPID/ }
  end
  describe file('/etc/default/prometheus-node-exporter') do
    it { should be_file }
    its(:content) {should match /ARGS/ }
  end
end
