function Set-VirtualSwitches () {
    New-VMSwitch -Name project_wan_sw -SwitchType Internal
    New-VMSwitch -Name project_frontend_sw -SwitchType Private
    New-VMSwitch -Name project_backend_sw -SwitchType Private
    New-VMSwitch -Name project_management_sw -SwitchType Private
}
Set-VirtualSwitches;