control 'statsd exporter should be installed' do
  describe file('/opt/prometheus/bin/statsd_exporter') do
    it { should be_file }
    it { should be_executable }
  end
end
control 'it should be running under systemd' do
  describe file('/etc/systemd/system/prometheus-statsd_exporter.service') do
    it { should be_file }
    its(:content) { should match /MAINPID/ }
  end
  describe file('/etc/default/prometheus-statsd_exporter') do
    it { should be_file }
    its(:content) { should match /ARGS/ }
  end
end
