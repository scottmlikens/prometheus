control 'it should have alertmanager installed' do
  describe file('/usr/bin/alertmanager') do
    it { should be_file }
    it { should be_executable }
  end
  describe file('/usr/bin/amtool') do
    it { should be_file }
    it { should be_executable }
  end
end
