control 'it should prometheus running and responding to curl' do
  describe command("/usr/bin/curl -v http://localhost:9090") do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /Found/ }
  end
end
