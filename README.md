# Get-ADDeviceList.ps1

PowerShell script for querying Active Directory computer objects within a specified Organizational Unit (OU) and exporting the results to a CSV file. The script is modular, using a configurable environment block for domain, OU base path, and default output directory.

## Features

* Configurable environment block for easy deployment across domains.
* Optional OU targeting for precise queries.
* Optional CSV path override for flexible output locations.
* Debug mode for console-only output (no file creation).
* Exports system name, operating system, last logon date, and enabled status.

## Configuration

Edit the `$config` block at the top of the script to match your environment:

```powershell
$config = @{
    DebugMode        = $true
    DomainName       = "#INSERT_DOMAIN_HERE"
    BaseOU           = "OU=#INSERT_BASE_OU_HERE,DC=#INSERT_DC1_HERE,DC=#INSERT_DC2_HERE,DC=#INSERT_DC3_HERE"
    DefaultCSVFolder = "#INSERT_DEFAULT_PATH_HERE"
}
```

## Requirements

* Windows PowerShell 5.1 or newer
* ActiveDirectory module installed (`Install-WindowsFeature RSAT-AD-PowerShell`)

## License

MIT License
