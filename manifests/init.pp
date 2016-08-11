class powershell5 (
  $path = "C:/temp/",
  $installer = "Win8.1AndW2K12R2-KB3134758-x64.msu",
  $installscript = "install.ps1",
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
  file { "ps_installer_script":
    ensure => 'present',
    source => "puppet:///modules/powershell5/${installscript}",
    path   => "${path}${installscript}",
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

}
