class powershell5 (
  $path = "C:/temp/",
  $installer = "Win8.1AndW2K12R2-KB3134758-x64.msu",
  $installscript = "install.ps1",
) {

  if (0 + $::powershell_version_major) < 5 {
    notify {" Powershell is less than 5":}
  
  # Create staging directory and download file to local machine 
  file { "temp":
    path   => "${path}",
    ensure => 'directory',
  }
  file { "ps_installer":
    ensure => 'present',
    source => "puppet:///modules/powershell5/${installer}",
    path   => "${path}${installer}",
    require  => File["temp"],
  }

  # service needs to be running to install the update
  service { 'wuauserv':
    ensure  => 'running',
    enable => 'true',
  }

  # disable auto updating so machine doesnt start downloading / updating
  registry::value { 'disable updates':
    key   => 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU',
    value => 'NoAutoUpdate',
    data  => "1",
    type  => 'dword',
  }

  # Exec Command to install the msu package from  the staging path silently.  Reboot is required for update to take effect. 
  exec { 'run_install_script':
    command  => "wusa ${path}Win8.1AndW2K12R2-KB3134758-x64.msu /quiet /norestart",
    provider => powershell,
    require  => [File['ps_installer'],Service['wuauserv']],
  }
  
  # Reboot after installing update to apply update
  reboot { 'after':
      subscribe => Exec['run_install_script'],
  }
  
  }
  else {
    notify {'Powershell is version 5 or greater':}
  }
}
