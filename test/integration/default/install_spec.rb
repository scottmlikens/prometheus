control 'it should have prometheus installed' do
  describe file('/opt/prometheus/bin/prometheus-2.16.0') do
    it { should be_file }
    it { should be_executable }
  end
  describe file('/opt/prometheus/bin/promtool-2.16.0') do
    it { should be_file }
    it { should be_executable }
  end
  describe file('/usr/share/doc/prometheus/examples') do
    it { should be_directory }
  end
  describe file('/usr/share/doc/prometheus/examples/consoles/prometheus-overview.html') do
    it { should be_file }
  end
end
