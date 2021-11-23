#variables for common values
$resourceGroup = "myResourceGroup"
$location = "CentralUS"
$vmName = "myVM1"

# create user object
$username= "Srinidhi"
$password = ConvertTo-SecureString -String "P2ssw0rd" -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $password

#Create a resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

#Create subnet configuration
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name mysubnet -AddressPrefix 192.168.1.0/24

#Create a virtual network
$vnet = New-AzVirtualNetwork -Name myVnet -ResourceGroupName $resourceGroup -Location $location -AddressPrefix 192.168.0.0/16 -subnet $subnetConfig

#create a public ip and specify a DNS name
$pip = New-AzPublicIpAddress -ResourceGroupName $resourceGroup -Location $location `
-Name "mypublicdns$(Get-Random)" -AllocationMethod Static -IdleTimeOutInMinutes 4

#Create an inbound Network Security Group rule for 3389
$nsgRuleRdp = New-AzNetworkSecurityRuleConfig -Name myNSGRuleRDP -Protocol TCP -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow

#Create a Virtual NIC and associate wiht NSG and Public IP address
$nic = New-AzNetworkInterface -Name myNic -ResourceGroupName $resourceGroup -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

#Create virtual machine configuration 
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize Standard_A1_V2 
Set-AzVMOperatingSystem -VM $vmConfig -Windows -ComputerName $vmName -Credential $cred | `
Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version latest | `
Add-AzVMNetworkInterface -Id $nic.Id

#Create a virtual machine
New-AzVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig

