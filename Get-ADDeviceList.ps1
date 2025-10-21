# CONFIG BLOCK
$config = @{
    DebugMode        = $true
    DomainName       = "#INSERT_DOMAIN_HERE"
    BaseOU           = "OU=#INSERT_BASE_OU_HERE,DC=#INSERT_DC1_HERE,DC=#INSERT_DC2_HERE,DC=#INSERT_DC3_HERE"
    DefaultCSVFolder = "#INSERT_DEFAULT_PATH_HERE"
}

param(
    [string]$OU,         
    [string]$CSVpath     
)

$debug    = $config.DebugMode
$domain   = $config.DomainName
$baseOU   = $config.BaseOU
$today    = Get-Date -Format 'yyyyMMdd'

if ($OU) {
    $targetOU = "OU=$OU,$baseOU"
} else {
    $targetOU = $baseOU
}

if ($CSVpath) {
    if ($CSVpath -match '\.csv$') {
        $outputCSV = $CSVpath
    } else {
        $fileName = if ($OU) { "${today}_${OU}_DeviceList.csv" } else { "${today}_DeviceList.csv" }
        $outputCSV = Join-Path $CSVpath $fileName
    }
} else {
    $fileName = if ($OU) { "${today}_${OU}_DeviceList.csv" } else { "${today}_DeviceList.csv" }
    $outputCSV = Join-Path $config.DefaultCSVFolder $fileName
}

# FUNCTION BLOCK
function Get-ADComputers {
    param(
        [Parameter(Mandatory)]
        [string]$Server,
        [Parameter(Mandatory)]
        [string]$SearchBase,
        [string]$SearchScope  = 'Subtree',
        [string]$Filter       = '*',
        [string[]]$Properties = @('OperatingSystem','LastLogonDate','Enabled')
    )

    $params = @{
        Server      = $Server
        SearchBase  = $SearchBase
        SearchScope = $SearchScope
        Filter      = $Filter
        Properties  = $Properties
    }

    Get-ADComputer @params | Select-Object Name, DistinguishedName, OperatingSystem, LastLogonDate, Enabled
}

# EXECUTION BLOCK
if ($debug) {
    Write-Host "`n[DEBUG MODE ON]"
    Write-Host "Domain: $domain"
    Write-Host "Target OU: $targetOU"
    Write-Host "CSV path: $outputCSV`n"
}

$computers = Get-ADComputers `
    -Server $domain `
    -SearchBase $targetOU

if ($debug) {
    $computers | Format-Table -AutoSize
    Write-Host "`n(No CSV file was created. Debug mode is ON.)"
}
else {
    $computers | Export-Csv -Path $outputCSV -NoTypeInformation
    Write-Host "Device list exported to $outputCSV"
}
