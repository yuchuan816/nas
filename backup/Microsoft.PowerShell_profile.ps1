Function SSHRmote {
    ssh tom@home.server
}
Set-Alias -Name nas -Value SSHRmote

Function WakeonLAN {
    wol -m 1c:86:0b:26:fd:45
}
Set-Alias -Name wnas -Value WAKEonLAN

Function EnterUbuntu {
    ubuntu2404.exe
}
Set-Alias -Name vm -Value EnterUbuntu

Function SSHRouter {
    ssh root@openwrt.lan
}
Set-Alias -Name router -Value SSHRouter