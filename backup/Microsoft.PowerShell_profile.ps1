Function SSHRmote {
    ssh tom@home.server
}
Set-Alias -Name nas -Value SSHRmote

Function EnterUbuntu {
    ubuntu2404.exe
}
Set-Alias -Name vm -Value EnterUbuntu

Function SSHRouter {
    ssh root@openwrt.lan
}
Set-Alias -Name router -Value SSHRouter