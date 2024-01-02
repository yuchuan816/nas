Function SSHRmote {
    ssh tom@nas.com
}
Set-Alias -Name nas -Value SSHRmote


Function WakeonLAN {
    wol -m 1c:86:0b:26:fd:45
}
Set-Alias -Name wnas -Value WAKEonLAN

Function WakeonLAN {
    ubuntu.exe
}
Set-Alias -Name vm -Value Ubuntu
