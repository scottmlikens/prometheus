control 'it should have prometheus installed' do
  describe file('/usr/bin/prometheus') do
    it { should be_file }
    it { should be_executable }
  end
  describe file('/usr/bin/promtool') do
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
