# Variables for common values
$resourceGroup = "myResourceGroup"
$location = "westeurope"
$vmName = "myVM"

$cred = Get-Credential -Message "Enter a user name and password for virtual machine."

#Create resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

# VM Creation

New-AzVM `
  -ResourceGroupName $resourceGroup `
  -Name $vmName `
  -Location $location `
  -Image "Win2016Datacenter" `
  -VirtualNetworkName "myvnet" `
  -SubnetName "mysubnet" `
  -SecurityGroupName "myNSG" `
  -PublicIpAddressName "mypublicIP" `
  -Credential $cred
  -OpenPorts 3389
