# Common functions for Full Kit PowerShell scripts

# Function to get the next feature number
function Get-NextFeatureNumber {
    param([string]$FeaturesDir)
    
    if (Test-Path $FeaturesDir) {
        # Find the highest numbered feature and increment
        $existingFeatures = Get-ChildItem -Path $FeaturesDir -Directory | Where-Object { $_.Name -match '^\d{3}-' }
        if ($existingFeatures) {
            $highestNum = ($existingFeatures.Name | ForEach-Object { [int]($_.Split('-')[0]) } | Measure-Object -Maximum).Maximum
            $nextNum = $highestNum + 1
        } else {
            $nextNum = 1
        }
    } else {
        $nextNum = 1
    }
    
    return $nextNum.ToString("000")
}

# Function to convert description to feature name
function Convert-DescriptionToFeatureName {
    param([string]$Description)
    
    # Convert to lowercase, replace spaces with hyphens, remove special characters
    $featureName = $Description.ToLower() -replace '[^a-z0-9-]', '-' -replace '-+', '-' -replace '^-|-$', ''
    return $featureName
}

# Function to create a new feature directory
function New-FeatureDirectory {
    param(
        [string]$BaseDir,
        [string]$FeatureDesc
    )
    
    $featureNum = Get-NextFeatureNumber -FeaturesDir $BaseDir
    $featureName = Convert-DescriptionToFeatureName -Description $FeatureDesc
    $featurePath = Join-Path $BaseDir "${featureNum}-${featureName}"
    
    New-Item -ItemType Directory -Path $featurePath -Force | Out-Null
    return $featurePath
}

# Function to validate constitution exists
function Test-ConstitutionExists {
    $constitutionPath = Join-Path (Get-Location) "memory" "constitution.md"
    if (-not (Test-Path $constitutionPath)) {
        Write-Error "Project constitution not found. Run /fullkit.constitution first."
        exit 1
    }
}

# Function to check if git branch exists and create if needed
function Set-GitBranch {
    param([string]$BranchName)
    
    $branchExists = git branch --list $BranchName | Measure-Object
    if ($branchExists.Count -eq 0) {
        git checkout -b $BranchName
    } else {
        git checkout $BranchName
    }
}