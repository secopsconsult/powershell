<#

   .Synopsis
      Command to List Wifi network connections that have been saved, their key.

   .DESCRIPTION
      Command that goes through each saved Wifi Connection and lists all saved connections, their type and the key.

   .EXAMPLE
        get-WifiCreds
            Lists the Wifi Networks and the keys.

#>

 

function get-WifiCreds
{

     [CmdletBinding()]
     [OutputType([string])]
 
     Param
     (
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
                      Write-Output "$out, <open>"
                  } else 
                  {
                      $key = $profile | select-string -Pattern "Key Content"
                      if ($key) 
                      {
                          $key = ($key -split ":")[-1].Trim() -replace '"'
                      }
                      write-Output "$out, $pw2, $key"
                  }
              }
         }
     }


     End
     {
     }

} 
