function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[Parameter(Mandatory)]
		[System.String]
		$WUServer,

		[System.String]
		$UseWUServer,

		[System.String]
		$NoAutoUpdate,

		[System.String]
		$AUOptions,

		[System.String]
		$ScheduledInstallDay,

		[System.String]
		$ScheduledInstallTime,
		
		[System.String]
		$DetectionFrequency,
		
		[System.String]
		$DetectionFrequencyEnabled
		
	)
	# The registry path to WindowsUpdate
	$pathUpdate = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
	# The additional "AU" path underneath
	$pathAU = '$pathUpdate\AU'

	Write-Verbose "Getting existing Automatic Update registry settings."
	# will skip completely if the path doesn't exist and will only return if the path does exist
	if(test-path -path $pathUpdate -erroraction SilentlyContinue)
	{
		if(test-path -path '$pathUpdate\WUServer' -erroraction silentlycontinue)
		{
			$GetWUServer= (Get-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'  -name "WUServer").WUServer.Tostring()
		}
		else{$GetWUServer = ''}
		
		if(test-path -path '$pathUpdate\UseWUServer' -erroraction silentlycontinue)
		{
			$GetUseWUServer= (Get-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -name "UseWUServer").UseWUServer.Tostring()
		}
		else{$GetUseWUServer = ''}
		
		if(test-path -path '$pathAU\AUOptions' -erroraction silentlycontinue)
		{
			$GetAUOptions= (Get-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -name "AUOptions").AUOptions.Tostring()
		}
		else {$GetAUOptions = ''}
		
		if(test-path -path '$pathAU\NoAutoUpdate' -erroraction silentlycontinue)
		{	
			$GetNoAutoUpdate= (Get-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -name "NoAutoUpdate").NoAutoUpdate.Tostring()
		}
		else {$GetNoAutoUpdate = ''}
		
		if(test-path -path '$pathAU\ScheduledInstallDay' -erroraction silentlycontinue)
		{
			$GetSchedDay= (Get-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -name "ScheduledInstallDay").ScheduledInstallDay.Tostring()
		}
		else {$GetSchedDay = ''}
		
		if(test-path -path '$pathAU\ScheduledInstallTime' -erroraction silentlycontinue)
		{
			$GetSchedTime= (Get-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -name "ScheduledInstallTime").ScheduledInstallTime.Tostring()
		}
		else{$GetSchedTime = ''}
		
		if(test-path -path '$pathAU\DetectionFrequency' -erroraction silentlycontinue)
		{
			$GetDetectFreq= (Get-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -name "DetectionFrequency").DetectionFrequency.Tostring()
		}
		else{$GetDetectFreq = ''}
		
		if(test-path -path '$pathAU\DetectionFrequencyEnabled' -erroraction silentlycontinue)
		{
			$GetDetectFreqEn= (Get-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -name "DetectionFrequencyEnabled").DetectionFrequencyEnabled.Tostring()
		}
		else{$GetDetectFreqEn = ''}

}
	$returnValue = @{
            WUServer = $GetWUServer
			UseWUServer = $GetUseWUServer
			AUOptions = $GetAUOptions
			NoAutoUpdate = $GetNoAutoUpdate
			ScheduledInstallDay = $GetSchedDay
            ScheduledInstallTime = $GetSchedTime
			DetectionFrequency = $GetDetectFreq
			DetectionFrequencyEnabled = $GetDetectFreqEn
	        }
    

	$returnValue

}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		
		[Parameter(Mandatory)]
		[System.String]
		$WUServer,

		[System.String]
		$UseWUServer,

		[System.String]
		$NoAutoUpdate,

		[System.String]
		$AUOptions,

		[System.String]
		$ScheduledInstallDay,

		[System.String]
		$ScheduledInstallTime,
		
		[System.String]
		$DetectionFrequency,
		
		[System.String]
		$DetectionFrequencyEnabled
		
	)

	$intUseWUServer = [System.Byte]$UseWUServer
	$intNoAutoUpdate = [System.Byte]$NoAutoUpdate
	$intAUOptions = [System.Int16]$AUOptions
	$intScheduledInstallDay = [System.Int16]$ScheduledInstallDay
	$intScheduledInstallTime = [System.Int16]$ScheduledInstallTime
	$intDetectionFreq = [System.Int16]$DetectionFrequency
	$intDetectionFreqEn = [System.Int16]$DetectionFrequencyEnabled
	
	$UpdatePath = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
	$AUPath = $Updatepath+'\AU'
	
	# If anything is changed from the correct settings, the entire registry key is deleted and recreated 
	# with the setting specified
	
	Write-Verbose "Writing new Automatic Update registry settings."
	remove-item $updatepath -recurse -force
	new-item $updatepath
	new-item $aupath
	New-ItemProperty -Path $updatepath -name "WUServer" -value $WUServer 
	New-ItemProperty -Path $updatepath -name "WUStatusServer" -value $WUServer
	New-ItemProperty -Path $aupath -name "UseWUServer" -value $intUseWUServer -propertytype 'DWORD'
	New-ItemProperty -Path $aupath -name "NoAutoUpdate" -value $intNoAutoUpdate -propertytype 'DWORD'
	New-ItemProperty -Path $aupath -name "AUOptions" -value $intAUOptions -propertytype 'DWORD'
	New-ItemProperty -Path $aupath -name "ScheduledInstallDay" -value $intScheduledInstallDay -propertytype 'DWORD'
	New-ItemProperty -Path $aupath -name "ScheduledInstallTime" -value $intScheduledInstallTime -propertytype 'DWORD'
	New-ItemProperty -Path $aupath -name "DetectionFrequency" -value $intDetectionFreq -propertytype 'DWORD'
	New-ItemProperty -Path $aupath -name "DetectionFrequencyEnabled" -value $intDetectionFreqEn -propertytype 'DWORD'

}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$WUServer,

		[System.String]
		$UseWUServer,

		[System.String]
		$NoAutoUpdate,

		[System.String]
		$AUOptions,

		[System.String]
		$ScheduledInstallDay,

		[System.String]
		$ScheduledInstallTime,
		
		[System.String]
		$DetectionFrequency,
		
		[System.String]
		$DetectionFrequencyEnabled
	)

	$result = $true
	
	# Reset if any one of the changes isn't what was requested in the parameters when calling this resource
	if(($WUServer -eq $GetWUServer) -and ($UseWUServer -eq $GetUseWUServer) -and ($NoAutoUpdate -eq $GetNoAutoUpdate) -and ($ScheduledInstallDay -eq $GetSchedDay) -and ($ScheduledInstallTime -eq $GetSchedTime) -and ($DetectionFrequency -eq $GetDetectFreq) -and ($DetectionFrequencyEnabled -eq $GetDetectFreqEn))
	{
		Write-Verbose "Automatic Update Options already match requested settings."  
	}
	else
	{
		Write-Verbose "At least one Automatic Update option needs to be changed."
		$result = $false
	}
	
	$result
	
}


Export-ModuleMember -Function *-TargetResource

