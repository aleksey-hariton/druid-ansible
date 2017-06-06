# test that sudoers don't need password
control 'Check Druid' do

  # Druid folder exists
  describe file('/opt/druid/') do
    it { should exist }
  end

  # [UI] (Overlord) Coordinator console available
  describe command('curl -vLk http://localhost:8090/') do
    its('stdout') { should match (/Druid Indexer Coordinator Console/) }
  end

  # [API] Coordinator available
  describe command('curl -vLk http://localhost:8081/status') do
    its('stdout') { should match (/"version":/) }
  end

  # [API] Broker available
  describe command('curl -vLk http://localhost:8082/status') do
    its('stdout') { should match (/"version":/) }
  end

  # [API] Historical available
  describe command('curl -vLk http://localhost:8083/status') do
    its('stdout') { should match (/"version":/) }
  end

  # [API] MiddleManager available
  describe command('curl -vLk http://localhost:8091/status') do
    its('stdout') { should match (/"version":/) }
  end
end