class powershell5 (
  $path = "C:\\temp\\",
  $installer = "Win8\.1AndW2K12R2\-KB3134758\-x64\.msu",
) {

  file { "${path}${installer}":
    ensure => 'present',
    source => "puppet:///powershell5/${installer}",
  }

  service { 'windows update':
    ensure  => 'running',
    enabled => 'true',
  }

}
