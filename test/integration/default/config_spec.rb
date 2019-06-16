control 'it should be configured' do
  describe file('/etc/prometheus') do
    it { should be_directory }
  end
  describe file('/etc/prometheus/prometheus.yml') do
    it { should be_file }
    its(:content) { should match /scrape_interval/ }
    its(:content) { should match /external_labels/ }
  end
end
