#request privilege
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) { Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs; exit }

#stop service
net stop com.docker.service

#stop processes
$processName = @("com.docker.backend.exe","com.docker.dev-envs.exe","com.docker.proxy.exe","vpnkit-bridge.exe")

for ( $index = 0; $index -lt $processName.count; $index++)
{
    $isrunning = Get-Process $processName[$index] -ErrorAction SilentlyContinue
    if ($isrunning) {
        $isrunning.CloseMainWindow()
        $isrunning | Stop-Process -Force
    }
}

#restart
Start-Process -FilePath "C:\Program Files\Docker\Docker\resources\com.docker.dev-envs.exe"
Start-Process -FilePath "C:\Program Files\Docker\Docker\resources\vpnkit-bridge.exe"
Start-Process -FilePath "C:\Program Files\Docker\Docker\resources\com.docker.backend.exe"

net start com.docker.service



