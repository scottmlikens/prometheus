control 'statsd exporter should be installed' do
  describe file('/usr/bin/statsd_exporter') do
    it { should be_file }
    it { should be_executable }
  end
end
control 'it should be running under systemd' do
  describe file('/etc/systemd/system/prometheus-statsd-exporter.service') do
    it { should be_file }
    its(:content) { should match /MAINPID/ }
  end
  describe file('/etc/default/prometheus-statsd-exporter') do
    it { should be_file }
    its(:content) { should match /ARGS/ }
  end
end
