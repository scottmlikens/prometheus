control 'it should be running under systemd' do
  describe file('/etc/systemd/system/alertmanager.service') do
    it { should be_file }
    its(:content) { should match /MAINPID/ }
  end
  describe file('/etc/default/alertmanager') do
    it { should be_file }
    its(:content) {should match /ARGS/ }
  end
end
