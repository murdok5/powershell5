class powershell5 (
  $path = "C:/temp/",
  $installer = "Win8.1AndW2K12R2-KB3134758-x64.msu",
  $installscript = "install.ps1",
) {

  file { "temp":
    path   => "${path}",
    ensure => 'directory',
  }
  
  file { "ps_installer":
    ensure => 'present',
    source => "puppet:///modules/powershell5/${installer}",
    path   => "${path}${installer}",
    after  => File["temp"],
  }
  # file { "ps_installer_script":
  #  ensure => 'present',
  #  source => "puppet:///modules/powershell5/${installscript}",
  #  path   => "${path}${installscript}",
  #  after  => File["${path}"],
  #}

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

  exec { 'run_install_script':
    #command => file("${path}${installscript}"),
    command  => "wusa ${path}Win8.1AndW2K12R2-KB3134758-x64.msu /quiet /norestart",
    provider => powershell,
    #after   => File['ps_installer_script'],
  }

}
