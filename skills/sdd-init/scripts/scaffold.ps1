<#
.SYNOPSIS
  sdd-scaffold-plugin — scaffold.ps1
  Creates the .agents/ SDD scaffold in a target project directory.

.DESCRIPTION
  Non-interactive CLI scaffold for Spec-Driven Development projects.
  Use this as a fast-path alternative to the agent-driven `sdd-init` skill.

.PARAMETER ProjectName
  (Required) Project name used in templates. Example: "my-project"

.PARAMETER Stack
  (Required) Primary technology stack (metadata only). Example: "dotnet/aspnet"

.PARAMETER SpecsDir
  (Optional) Directory for spec files. Default: "specs"

.PARAMETER Governance
  (Optional) "personal" or "team". Default: "personal"

.PARAMETER TargetDir
  (Optional) Target project root path. Default: current working directory

.EXAMPLE
  .\scaffold.ps1 -ProjectName "my-api" -Stack "dotnet/aspnet" -Governance "team"
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]  [string]$ProjectName,
  [Parameter(Mandatory = $true)]  [string]$Stack,
  [Parameter(Mandatory = $false)] [string]$SpecsDir = "specs",
  [Parameter(Mandatory = $false)] [string]$Governance = "personal",
  [Parameter(Mandatory = $false)] [string]$TargetDir = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

# --- Resolve paths ---
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PluginDir = Resolve-Path (Join-Path $ScriptDir "..\..") 
$TemplatesDir = Join-Path $PluginDir "skills\sdd-init\resources\templates"
$Date = Get-Date -Format "yyyy-MM-dd"
$AgentsDir = Join-Path $TargetDir ".agents"
$SpecsPath = Join-Path $TargetDir $SpecsDir

# --- Helper: render template ---
function Render-Template {
  param([string]$TemplatePath, [string]$OutputPath)
  $content = Get-Content $TemplatePath -Raw -Encoding UTF8
  $content = $content `
    -replace '\{\{PROJECT_NAME\}\}', $ProjectName `
    -replace '\{\{STACK\}\}', $Stack `
    -replace '\{\{DATE\}\}', $Date `
    -replace '\{\{SPECS_DIR\}\}', $SpecsDir `
    -replace '\{\{GOVERNANCE_MODE\}\}', $Governance
  Set-Content -Path $OutputPath -Value $content -Encoding UTF8
}

# --- Create directories ---
New-Item -ItemType Directory -Force -Path $AgentsDir | Out-Null
New-Item -ItemType Directory -Force -Path $SpecsPath  | Out-Null
Write-Host "  [+] Created .agents/"
Write-Host "  [+] Created $SpecsDir/"

# --- Render AGENTS.md ---
$agentsMd = Join-Path $AgentsDir "AGENTS.md"
if (-not (Test-Path $agentsMd)) {
  Render-Template (Join-Path $TemplatesDir "AGENTS.md.tmpl") $agentsMd
  Write-Host "  [+] Created .agents/AGENTS.md"
}
else {
  Write-Host "  [~] Skipped .agents/AGENTS.md (already exists)"
}

# --- Render plugins.json ---
$pluginsJson = Join-Path $AgentsDir "plugins.json"
if (-not (Test-Path $pluginsJson)) {
  Render-Template (Join-Path $TemplatesDir "plugins.json.tmpl") $pluginsJson
  Write-Host "  [+] Created .agents/plugins.json"
}
else {
  Write-Host "  [~] Skipped .agents/plugins.json (already exists)"
}

# --- Create specs placeholder ---
$gitkeep = Join-Path $SpecsPath ".gitkeep"
if (-not (Test-Path $gitkeep)) {
  New-Item -ItemType File -Path $gitkeep | Out-Null
  Write-Host "  [+] Created $SpecsDir/.gitkeep"
}

Write-Host ""
Write-Host "✅ SDD scaffold created for '$ProjectName' ($Stack)" -ForegroundColor Green
Write-Host ""
Write-Host "Next step: activate the 'spec-architect' skill to write your first spec."

