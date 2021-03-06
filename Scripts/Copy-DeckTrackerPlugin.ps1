#Requires -Version 3.0

Param(	
	[string]$ProjectName,
	[string]$ProjectDir,
	[string]$Config="Release",
	[string]$Platform="x86"
)

$AppDir = "$env:LOCALAPPDATA\HearthstoneDeckTracker"
$DataDir = "$env:APPDATA\HearthstoneDeckTracker"

if (-not $ProjectName) {
	Write-Output "-ProjectName is required"	
	Return
}

if (-not $ProjectDir) {
	$ProjectDir = $(Get-Location).Path
}

$hdt = Get-Process "HearthstoneDeckTracker" -ErrorAction SilentlyContinue
if ($hdt) {
  Write-Output "Closing HDT"
  $hdt.CloseMainWindow() | out-null
  Sleep 4
  if (!$hdt.HasExited) {
    Write-Output "Forcing shutdown"
    $hdt | Stop-Process -Force
  }    
}
Remove-Variable hdt

if (-not (test-path "$DataDir\Plugins")) {
	mkdir "$DataDir\Plugins" | out-null
}
Copy-Item "$ProjectDir\$ProjectName\bin\$Platform\$Config\$ProjectName.dll" "$DataDir\Plugins\" -Force
Sleep 2
Write-Output "Starting HDT"
Start-Process "$AppDir\Update.exe" -ArgumentList "--processStart","HearthstoneDeckTracker.exe"

