control 'it should be configured' do
  describe file('/etc/prometheus') do
    it { should be_directory }
  end
  describe file('/etc/prometheus/alertmanager.yml') do
    it { should be_file }
    its(:content) { should match /resolve_timeout/ }
    its(:content) { should match /receivers/ }
  end
end
