param (
    [string]$Configuration = "Release"
)

$ErrorActionPreference = "Stop"
$packagesPath = Join-Path $PSScriptRoot "local-packages"

Write-Host "Package output directory: $packagesPath"

# Ensure packages directory exists and is clean
if (Test-Path $packagesPath) {
    Remove-Item -Path $packagesPath -Recurse -Force
    Write-Host "Cleaned existing packages directory"
}
New-Item -ItemType Directory -Path $packagesPath -Force | Out-Null
Write-Host "Created packages directory at: $packagesPath"

# Restore dependencies
Write-Host "Restoring dependencies..."
dotnet restore

# Build solution
Write-Host "Building solution in $Configuration configuration..."
dotnet build --configuration $Configuration --no-restore

# Initialize arrays to track projects
$skippedProjects = @()
$packedProjects = @()

# Pack projects explicitly
Write-Host "`nProcessing projects..."
Get-ChildItem -Path "src", "analyzers" -Filter "*.csproj" -Recurse | ForEach-Object {
    $projectName = $_.Name
    
    # Check if project should be skipped
    if ($projectName -like "*.Vsix.csproj" -or 
        $projectName -like "*.Test.csproj" -or 
        $projectName -like "*.Tests.*.csproj") {
        $skippedProjects += $projectName.Replace(".csproj", "")
    }
    else {
        Write-Host "Packing $projectName..."
        dotnet pack $_.FullName --configuration $Configuration --no-build --output $packagesPath
        $packedProjects += $projectName.Replace(".csproj", "")
    }
}

# Display results
Write-Host "`n=== Build Summary ==="
Write-Host "`nPackages generated ($($packedProjects.Count)):"
$packedProjects | Sort-Object | ForEach-Object {
    Write-Host "- $_"
}

Write-Host "`nProjects skipped ($($skippedProjects.Count)):"
$skippedProjects | Sort-Object | ForEach-Object {
    Write-Host "- $_"
}

Write-Host "`nAll packages are available in: $packagesPath"