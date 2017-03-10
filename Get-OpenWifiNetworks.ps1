<#

   .Synopsis
      Command to List / delete open Wifi network connections that have been saved.

   .DESCRIPTION
      Command that goes through each saved Wifi Connection and lists all saved connections which have Open Authentication

   .EXAMPLE
        get-OpenWifiNetworks
            Lists the Open Wifi Networks.

   .EXAMPLE
        get-OpenWifiNetworks -delete
            Deletes the Open Wifi Networks

#>

function get-OpenWifiNetworks
{

     [CmdletBinding()]
     [OutputType([string])]

     Param
     (
           # Param1 help description
           [Parameter(Mandatory=$false,
                      ValueFromPipelineByPropertyName=$false,
                      Position=0)]
           [switch]$delete  

     )

     Begin
     {
     }

     Process
     {

       # Run the Netsh command to determine all wifi profiles.
       $Output = netsh wlan show profiles

       $SSID = $Output | Select-String -Pattern 'All User Profile'

       Foreach ($sid in $SSID)
       {
            $out = ($sid -split ":")[-1].Trim() -replace '"'
            $profile = netsh wlan show profiles name=$out key=clear
            $pw = $profile | select-string -Pattern "Authentication"
            if ($pw) 
	    {
                $pw2 = ($pw -split ":")[-1].Trim() -replace '"'
                if ($pw2 -eq "Open") 
		{
                    if ($delete) 
		    {
                        netsh wlan delete profile name=$out
                    } else 
                    {
                        Write-Output "$out"
                    }
                }
            }
        }
     }

     End

     {
     }

}
