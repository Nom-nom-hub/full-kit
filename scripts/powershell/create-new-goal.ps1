# PowerShell script to create a new goal using the goal template

param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$GoalDescription
)

# Join all arguments into a single string
$goalDescString = ($GoalDescription -join " ").Trim()

if ([string]::IsNullOrEmpty($goalDescString)) {
    Write-Host "Error: Goal description is required" -ForegroundColor Red
    Write-Host "Usage: .\create-new-goal.ps1 `"Goal description goes here`"" -ForegroundColor Yellow
    exit 1
}

# Dot source the common functions
$scriptDir = Split-Path -Parent $PSCommandPath
. "$scriptDir\common.ps1"

Test-ConstitutionExists

# Create the goals directory if it doesn't exist
$goalsDir = Join-Path (Get-Location) "goals"
New-Item -ItemType Directory -Path $goalsDir -Force | Out-Null

# Create the new goal directory and file
$goalPath = New-FeatureDirectory -BaseDir $goalsDir -FeatureDesc $goalDescString
$goalFile = Join-Path $goalPath "goal.md"

# Use the goal template to create the goal file
$templatePath1 = Join-Path (Get-Location) ".fullkit" "templates" "goal-template.md"
$templatePath2 = Join-Path (Get-Location) "templates" "goal-template.md"

if (Test-Path $templatePath1) {
    Copy-Item $templatePath1 $goalFile
}
elseif (Test-Path $templatePath2) {
    Copy-Item $templatePath2 $goalFile
}
else {
    $goalContent = @"
# Goal: $goalDescString

## Strategic Objective
[Define the high-level business goal or strategic objective]

## Desired Outcomes
- [Measurable outcome 1]
- [Measurable outcome 2]

## Success Metrics
- [Metric 1 with target value]
- [Metric 2 with target value]

"@
    Set-Content -Path $goalFile -Value $goalContent
}

# Create/update the git branch for this goal
$featureName = Split-Path $goalPath -Leaf
Set-GitBranch -BranchName $featureName

Write-Host "Created goal: $goalFile" -ForegroundColor Green
Write-Host "Branch: $featureName" -ForegroundColor Green