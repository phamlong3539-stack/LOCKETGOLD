# Script to upload files to GitHub repository using GitHub Contents REST API
param (
    [Parameter(Mandatory = $true)]
    [string]$GitHubToken,

    [string]$Owner = "phamlong3539-stack",
    [string]$Repo = "LOCKETGOLD",
    [string]$Branch = "main"
)

$filesToUpload = @("forceGold4.2.js", "locketfix.js", "locketheader.js", "README.md")
$scriptDir = $PSScriptRoot

$headers = @{
    "Authorization" = "Bearer $GitHubToken"
    "Accept"        = "application/vnd.github.v3+json"
    "User-Agent"    = "PowerShell-Antigravity"
}

foreach ($fileName in $filesToUpload) {
    $filePath = Join-Path $scriptDir $fileName
    if (!(Test-Path $filePath)) {
        Write-Warning "File not found: $filePath"
        continue
    }

    $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
    $base64Content = [System.Convert]::ToBase64String($fileBytes)

    # Check if file already exists in repo to get SHA
    $checkUrl = "https://api.github.com/repos/$Owner/$Repo/contents/$fileName?ref=$Branch"
    $sha = $null
    try {
        $existing = Invoke-RestMethod -Uri $checkUrl -Headers $headers -Method Get -ErrorAction Stop
        $sha = $existing.sha
        Write-Host "File '$fileName' already exists. Updating (SHA: $sha)..."
    } catch {
        if ($_.Exception.Response.StatusCode.value__ -eq 404) {
            Write-Host "File '$fileName' does not exist yet. Creating new file..."
        } else {
            Write-Error "Error checking file '$fileName': $($_.Exception.Message)"
            continue
        }
    }

    $bodyObj = @{
        message = "Sync $fileName from Gist"
        content = $base64Content
        branch  = $Branch
    }
    if ($sha) {
        $bodyObj["sha"] = $sha
    }

    $bodyJson = $bodyObj | ConvertTo-Json
    $putUrl = "https://api.github.com/repos/$Owner/$Repo/contents/$fileName"

    try {
        $uploadResp = Invoke-RestMethod -Uri $putUrl -Headers $headers -Method Put -Body $bodyJson -ContentType "application/json; charset=utf-8"
        Write-Host "Successfully synced: $fileName -> $($uploadResp.content.html_url)" -ForegroundColor Green
    } catch {
        Write-Error "Failed to upload $fileName: $($_.Exception.Message)"
    }
}
