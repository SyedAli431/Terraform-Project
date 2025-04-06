control "vpc_exists" do
  impact 1.0
  title "Check if VPC exists"
  
  describe aws_vpc(vpc_id: input('vpc_id')) do
    it { should exist }
    its('cidr_block') { should eq '100.64.0.0/16' }
    its('tags') { should include('Name' => 'lab5-vpc') }
  end
end