facter.add(:powershell_version) do
  setcode do
    Facter::Core::Execution.exec('ps_version.ps1')
  end
end
