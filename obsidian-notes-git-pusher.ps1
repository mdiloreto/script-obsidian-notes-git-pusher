function Sync-RemoteObsidian {
    param (
        [string] $Path
    )
    # Start-Transcript "C:\logs\tasklog.txt"
    Set-Location -Path $Path
    Get-ChildItem -Path $Path -Directory | ForEach-Object { 
        $repo = $_.Name
        Set-Location -Path $repo

        try {
            git fetch
            $status = git status

            if ($status -match "nothing to commit, working tree clean") {
                Write-Output "$repo is up to date."
            } elseif ($status -match "Your branch is behind") {
                Write-Output "$repo is behind the remote. Pulling latest changes..."
                git pull
            } elseif ($status -match "Changes not staged for commit") {
                Write-Output "$repo has changes not staged for commit. Attempting to stage changes..."
                git add .
                git commit -m "Automated Script Update" && git push
            } else {
                Write-Output "$repo has other status: $status"
            }
        } catch {
            Write-Output "An error occurred in ${repo}: $_"
        }

        # Return to the main directory after processing
        Set-Location -Path $Path
        # Stop-Transcript
    }
}

# Run the function
$path = "C:\Users\Mateo\OneDrive\Documentos\Obsidian Notes"
Sync-RemoteObsidian -Path $path
