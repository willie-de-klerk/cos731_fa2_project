# https://www.serverwatch.com/guides/how-to-set-and-remove-hyper-v-virtual-machine-dvd-drives-in-bulk/



function Remove-VirtualMachines {

 #Create the Load Balancer Virtual Machines
    
 for (($i = 1); ($i -le 2); $i++){
    $sVmName = "project_load_balancer_"+$i
    $sFullDrivePath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\"+$sVmName+".vhdx"
    if (Test-Path -Path $sFullDrivePath){
        Stop-VM -Name $sVmName -Force
        Remove-VM -Name $sVmName -Force
        Remove-Item $sFullDrivePath

    }
} #End of LB For Loop

for (($i = 1); ($i -le 4); $i++){
    $sVmName = "project_frontend_vm_"+$i
    $sFullDrivePath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\"+$sVmName+".vhdx"
    if (Test-Path -Path $sFullDrivePath){
        Stop-VM -Name $sVmName -Force
        Remove-VM -Name $sVmName -Force
        Remove-VMHardDiskDrive -VMHardDiskDrive $sFullDrivePath

    }
} #End of Frontend VM For Loop

for (($i = 1); ($i -le 1); $i++){
    $sVmName = "project_backend_sql_vm_"+$i
    $sFullDrivePath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\"+$sVmName+".vhdx"
    if (Test-Path -Path $sFullDrivePath){
        Stop-VM -Name $sVmName -Force
        Remove-VM -Name $sVmName -Force
        Remove-Item $sFullDrivePath

    }   
} #End of Backend SQL VM For Loop

#Ansible VM
$sVmName = "project_management_vm"
    $sFullDrivePath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\"+$sVmName+".vhdx"
    if (Test-Path -Path $sFullDrivePath){
        Stop-VM -Name $sVmName -Force
        Remove-VM -Name $sVmName -Force
        Remove-Item $sFullDrivePath

    }   
 

#WAN Router VM
$sVmName = "project_wan_router_vm"
    $sFullDrivePath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\"+$sVmName+".vhdx"
    if (Test-Path -Path $sFullDrivePath){
        Stop-VM -Name $sVmName -Force
        Remove-VM -Name $sVmName -Force
        Remove-Item $sFullDrivePath

    }   

}


function main {
    $ErrorActionPreference = 'SilentlyContinue'

    Remove-VirtualMachines;        
}


main;