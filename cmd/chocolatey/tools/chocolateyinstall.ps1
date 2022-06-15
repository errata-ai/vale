$ErrorActionPreference = 'Stop';

$packageName = 'Vale'
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64       = 'https://github.com/errata-ai/vale/releases/download/v2.18.0/vale_2.18.0_Windows_64-bit.zip'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url64bit      = $url64

  checksum64      = '837da7b4b594743daa867eab3b78187bde2e2a6f7dc05d8052955ea49b24520f'
  checksumType64  = 'sha256'

}

Install-ChocolateyZipPackage @packageArgs