# requires AWSPowerShell module and asumes aws credentials are already configured

# params
$Region = "eu-south-2"
$InstanceType = "t2.nano"
$AMI = "ami-O70b208e993b59cea"
$KeyName = "ansible_keypair"
$SubnetId = "your-subnet-id"
$SecurityGroup = "default"
$InstanceCount = 3

$Instances = New-EC2Instance `
    -ImageId $AMI `
    -InstanceType $InstanceType `
    -KeyName $KeyName `
    -MinCount $InstanceCount `
    -MaxCount $InstanceCount `
    -SubnetId $SubnetId `
    -SecurityGroupId (Get-EC2SecurityGroup -GroupNames $SecurityGroup).GroupId `
    -AssociatePublicIp $true `
    -Region $Region

# set tag
foreach ($Instance in $Instances.Instances) {
    New-EC2Tag -Resources $Instance.InstanceId -Tags @{ Key = "Name"; Value = "Ansible-EC2-Test" } -Region $Region
}

# show instance details
$Instances.Instances | ForEach-Object {
    Write-Output "InstanceId: $($_.InstanceId), State: $($_.State.Name), PublicIP: $($_.PublicIpAddress)"
}
