control 'it should have alertmanager installed' do
  describe file('/opt/prometheus/bin/alertmanager-0.20.0') do
    it { should be_file }
    it { should be_executable }
  end
  describe file('/opt/prometheus/bin/amtool-0.20.0') do
    it { should be_file }
    it { should be_executable }
  end
end
