#!/usr/bin/env pwsh
param(
  [string]$Prefix = $env:PREFIX ? $env:PREFIX : 'paper',
  [string]$Min = $env:MIN ? $env:MIN : '1G',
  [string]$Max = $env:MAX ? $env:MAX : '4G',
  [string]$JvmOpts = $env:JVM_OPTS ? $env:JVM_OPTS : ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Set-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Path)

$jar = Get-ChildItem -File -Filter "*${Prefix}*.jar" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $jar) {
  Write-Error "No JAR found matching *$Prefix*.jar in $(Get-Location)"
}

Write-Host "Launching: java -Xmx$Max -Xms$Min $JvmOpts -jar $($jar.Name)"
& java "-Xmx$Max" "-Xms$Min" $JvmOpts -jar $jar.Name
