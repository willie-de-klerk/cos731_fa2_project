# https://www.serverwatch.com/guides/how-to-set-and-remove-hyper-v-virtual-machine-dvd-drives-in-bulk/

$hyperv = (Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online).State

function Get-LabSystemRequirements {
    Write-Host "Checking System Requirements..."
    $hyperv = (Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online).State
    if ($hyperv -ne 'Enabled'){
        $InstallHyperV = Read-Host 'Hyper-V is not enabled. Do you want to enable it? [Y] or [N]'
        $TermsandConditions = Read-Host 'Installing Hyper-V might lock your computer. Ensure you have your bitlocker key, can be found at microsoft online if registered to work account. and that you take blame for any damage not us. Continue? [Y] or [N]'
        if ($TermsandConditions -ne 'Y')
        {
            break;
        }
        if ($InstallHyperV -ne 'Y'){
            break;
        }
        try {
            Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All  
        }
        catch {
            Write-Host "An Error Occured, please verify that you are using a Windows edition that supports hyper-v"
        }
    }
    Write-Host "Get-LabSystemRequirements: Passed"
    
}



function Set-VirtualSwitches () {
    #Get-NetAdapter -Name * | Format-Table
    # Setting WAN Virtual Switch 
    #$sWANInterface = Read-Host "Please enter the name of the interface you would like to have for WAN. You can use either WiFi or Ethernet "
    #$sWANInterface = "Ethernet"
    #New-VMSwitch -Name project_wan_sw -NetAdapterName $sWANInterface
    New-VMSwitch -Name project_wan_sw -SwitchType Internal
    New-VMSwitch -Name project_frontend_sw -SwitchType Private
    New-VMSwitch -Name project_backend_sw -SwitchType Private
    New-VMSwitch -Name project_management_sw -SwitchType Private
}


function Set-NewVirtualMachines {

 #Create the Load Balancer Virtual Machines
    
 for (($i = 1); ($i -le 2); $i++){
    $sVmName = "project_load_balancer_"+$i
    $sFullDrivePath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\"+$sVmName+".vhdx"
    if (Test-Path -Path $sFullDrivePath){
        Stop-VM -Name $sVmName -Force
        Remove-VM -Name $sVmName -Force
        Remove-Item $sFullDrivePath
    }
    #Creating the VM
    New-VM -Name $sVmName -MemoryStartupBytes 512MB -Generation 2
    Set-VMFirmware -VMName $sVmName -EnableSecureBoot Off
    Set-VMProcessor -VMName $sVmName -Count 1
    Set-VMMemory $sVmName -DynamicMemoryEnabled $false
    #VM Storage
    New-VHD -Path $sFullDrivePath -SizeBytes 5GB
    Add-VMDvdDrive -VMName $sVmName -Path .\lb$i.iso
    Add-VMHardDiskDrive -VMName $sVmName -Path $sFullDrivePath
    #VM Networking
    Get-VM $sVmName | Add-VMNetworkAdapter -Name "project_wan_sw" -SwitchName project_wan_sw
    Get-VM $sVmName | Add-VMNetworkAdapter -Name "project_frontend_sw" -SwitchName project_frontend_sw
    Get-VM $sVmName | Add-VMNetworkAdapter -Name "project_backend_sw" -SwitchName project_backend_sw
    Get-VM $sVmName | Add-VMNetworkAdapter -Name "project_management_sw" -SwitchName project_management_sw
    Get-VM $sVmName | Remove-VMNetworkAdapter -VMNetworkAdapterName "Network Adapter"
    #VM Boot Order
    Set-VMFirmware -VMName $sVmName -BootOrder $(Get-VMDvdDrive -VMName $sVmName)
} #End of LB For Loop

for (($i = 1); ($i -le 4); $i++){
    $sVmName = "project_frontend_vm_"+$i
    $sFullDrivePath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\"+$sVmName+".vhdx"
    if (Test-Path -Path $sFullDrivePath){
        Stop-VM -Name $sVmName -Force
        Remove-VM -Name $sVmName -Force
        Remove-VMHardDiskDrive -VMHardDiskDrive $sFullDrivePath
    }
    #Creating the VM
    New-VM -Name $sVmName -MemoryStartupBytes 1GB -Generation 2
    Set-VMFirmware -VMName $sVmName -EnableSecureBoot Off
    Set-VMProcessor -VMName $sVmName -Count 1
    Set-VMMemory $sVmName -DynamicMemoryEnabled $false
    #VM Storage
    New-VHD -Path $sFullDrivePath -SizeBytes 8GB
    Add-VMDvdDrive -VMName $sVmName -Path .\fw$i.iso
    Add-VMHardDiskDrive -VMName $sVmName -Path $sFullDrivePath
    Get-VM $sVmName | Add-VMNetworkAdapter -Name "project_frontend_sw" -SwitchName project_frontend_sw
    Get-VM $sVmName | Remove-VMNetworkAdapter -VMNetworkAdapterName "Network Adapter"
    #VM Boot Order
    Set-VMFirmware -VMName $sVmName -BootOrder $(Get-VMDvdDrive -VMName $sVmName)
} #End of Frontend VM For Loop

for (($i = 1); ($i -le 1); $i++){
    $sVmName = "project_backend_sql_vm_"+$i
    $sFullDrivePath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\"+$sVmName+".vhdx"
    if (Test-Path -Path $sFullDrivePath){
        Stop-VM -Name $sVmName -Force
        Remove-VM -Name $sVmName -Force
        Remove-Item $sFullDrivePath

    }   
    #Creating the VM
    New-VM -Name $sVmName -MemoryStartupBytes 1GB -Generation 2
    Set-VMFirmware -VMName $sVmName -EnableSecureBoot Off
    Set-VMProcessor -VMName $sVmName -Count 1
    Set-VMMemory $sVmName -DynamicMemoryEnabled $false
    #VM Storage
    New-VHD -Path $sFullDrivePath -SizeBytes 10GB
    Add-VMDvdDrive -VMName $sVmName -Path .\sql$i.iso
    Add-VMHardDiskDrive -VMName $sVmName -Path $sFullDrivePath
    Get-VM $sVmName | Add-VMNetworkAdapter -Name "project_backend_sw" -SwitchName project_backend_sw
     Get-VM $sVmName | Remove-VMNetworkAdapter -VMNetworkAdapterName "Network Adapter"
    #VM Boot Order
    Set-VMFirmware -VMName $sVmName -BootOrder $(Get-VMDvdDrive -VMName $sVmName)
} #End of Backend SQL VM For Loop

#Ansible VM
$sVmName = "project_management_vm"
    $sFullDrivePath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\"+$sVmName+".vhdx"
    if (Test-Path -Path $sFullDrivePath){
        Stop-VM -Name $sVmName -Force
        Remove-VM -Name $sVmName -Force
        Remove-Item $sFullDrivePath

    }   
    #Creating the VM
    New-VM -Name $sVmName -MemoryStartupBytes 1512MB -Generation 2
    Set-VMFirmware -VMName $sVmName -EnableSecureBoot Off
    Set-VMProcessor -VMName $sVmName -Count 2
    Set-VMMemory $sVmName -DynamicMemoryEnabled $false
    #VM Storage
    New-VHD -Path $sFullDrivePath -SizeBytes 20GB
    Add-VMDvdDrive -VMName $sVmName -Path .\mgmnt.iso
    Add-VMHardDiskDrive -VMName $sVmName -Path $sFullDrivePath
    Get-VM $sVmName | Add-VMNetworkAdapter -Name "project_management_sw" -SwitchName project_management_sw
    Get-VM $sVmName | Add-VMNetworkAdapter -Name "project_wan_sw" -SwitchName project_wan_sw
    Get-VM $sVmName | Remove-VMNetworkAdapter -VMNetworkAdapterName "Network Adapter"
    #VM Boot Order
    Set-VMFirmware -VMName $sVmName -BootOrder $(Get-VMDvdDrive -VMName $sVmName)


#WAN Router VM
$sVmName = "project_wan_router_vm"
    $sFullDrivePath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\"+$sVmName+".vhdx"
    if (Test-Path -Path $sFullDrivePath){
        Stop-VM -Name $sVmName -Force
        Remove-VM -Name $sVmName -Force
        Remove-Item $sFullDrivePath

    }   
    #Creating the VM
    New-VM -Name $sVmName -MemoryStartupBytes 512MB -Generation 2
    Set-VMFirmware -VMName $sVmName -EnableSecureBoot Off
    Set-VMProcessor -VMName $sVmName -Count 1
    Set-VMMemory $sVmName -DynamicMemoryEnabled $false
    #VM Storage
    New-VHD -Path $sFullDrivePath -SizeBytes 5GB
    Add-VMDvdDrive -VMName $sVmName -Path .\wan_router.iso
    Add-VMHardDiskDrive -VMName $sVmName -Path $sFullDrivePath
    #VM Networking
    Get-VM $sVmName | Remove-VMNetworkAdapter -VMNetworkAdapterName "Network Adapter"
    Get-VM $sVmName | Add-VMNetworkAdapter -Name "Network Adapter" -SwitchName "Default Switch"
    Get-VM $sVmName | Add-VMNetworkAdapter -Name "project_wan_sw" -SwitchName project_wan_sw
    #VM Boot Order
    Set-VMFirmware -VMName $sVmName -BootOrder $(Get-VMDvdDrive -VMName $sVmName)
}


function main {
    $ErrorActionPreference = 'SilentlyContinue'
    Get-LabSystemRequirements;

    Set-NewVirtualMachines;    
    Get-VM;
    for ($i = 1; $i -le 100; $i++ ) {
        Write-Progress -Activity "OS installs are in Progress... This may take a while. Get some coffee. " -Status "$i% Complete:" -PercentComplete $i
        Start-Sleep -Seconds 9
    }
    Write-Host "Rebooting All Project Virtual Machines..."
    $iSleep = 30
    for ($i = 1; $i -le 4; $i++ ) {
        if ($i -eq 1) {
            Stop-VM "project_wan_router_vm"
            Start-Sleep $iSleep
            Start-Vm "project_wan_router_vm"
            Stop-VM "project_management_vm"
            Start-Sleep $iSleep
            Start-VM "project_management_vm"
            Stop-VM "project_backend_sql_vm_$i"
            Start-Sleep $iSleep
            Start-VM "project_backend_sql_vm_$i"
        }
        if ($i -le 2) {
            Stop-VM "project_load_balancer_$i"
            Start-Sleep $iSleep
            Start-VM "project_load_balancer_$i"
        }
        Stop-VM "project_frontend_vm_$i"
        Start-Sleep $iSleep
        Start-VM "project_frontend_vm_$i"
    }

    
    
}


main;