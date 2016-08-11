class powershell5 (
  $path = "C:/temp/",
  $installer = "Win8.1AndW2K12R2-KB3134758-x64.msu",
) {

   file { "${path}":
    ensure => 'directory',
    before => File['ps_installer'],
  }
  
  file { "ps_installer":
    ensure => 'present',
    source => "puppet:///modules/powershell5/${installer}",
    path   => "${path}${installer}",
  }

  # service needs to be running to install the update
  service { 'wuauserv':
    ensure  => 'running',
    enable => 'true',
  }

  # disable auto updating so machine doesnt start downloading / updating
  registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAutoUpdate':
    ensure   => present,
    type   => dword,
    data => "1",
  }

}
