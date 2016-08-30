# Powershell5

This is a basic module that completes a few tasks in our TSE Demo Environment, the main objective being to ensure that Powershell is installed to atleast version 5.0 to provide compatibility to the Puppet DSC and other modules.

This module does the following:

0 - Check for embedded fact of powershell_version_major to be less than 5.  If less than 5, it will proceed.  If it is 5 or greater nothing is done.
1 - Creates a temp directory (c:\temp)
2 - stages the MSU package for the update into this directory
3 - Enables and starts Windows Update Service (is disabled by default in our environment)
4 - Modifies a registry key to turn off auto-updating once the service is started to prevent updates being downloaded
5 - Executes a Powershell command to apply the update
6 - Reboots the computer after the update command


# Usage

Simply include this module, no parameters required.


# Supported OS

Currently tested on Windows Server 2012 r2
