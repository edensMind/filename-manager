# Tests Parameters
function Test-Params([string] $Path, [string] $Suffix) {
    if([string]::IsNullOrEmpty($Path) -or [string]::IsNullOrEmpty($Suffix)) {
        Write-Error "!! Parameters Cannot Be empty. Path: '$($Path)', Suffix: '$($Suffix)'"
        return $False
    }
    if(!$(Test-Path -Path $Path)) {
        Write-Error "!! The folder: $($Path) does not exist."
        return $False
    }
    return $True
}

# adds suffix to filename
function Add-Suffix {
    param(
        [string] $Path,
        [string] $Suffix
    )
    Begin {
        if([string]::IsNullOrEmpty($Path)) { $Path = Read-Host -Prompt "What folder do you want to add the suffix to all files?"}
        if([string]::IsNullOrEmpty($Suffix)) { $Suffix = Read-Host -Prompt "What suffix do you want to add to all files in this folder?"}
        $valid_params = $(Test-Params $Path $Suffix)
    }

    Process {
        if($valid_params) {
            Write-Host "Adding Suffix: $($Suffix)" -ForegroundColor Green
            Write-Host "Files in folder: $((Get-ChildItem $Path | Measure-Object).Count)" -ForegroundColor Cyan
            $ChangeCount = 0
            Get-ChildItem $Path | ForEach-Object {
                $org_name = [io.path]::GetFileNameWithoutExtension($_.FullName)
                # only add suffix if filename does not already have it
                if(!$($org_name -Match "$Suffix")) {
                    $new_name =  "$($org_name)$($Suffix)$($_.Extension)"
                    Write-Host $new_name
                    Rename-Item -LiteralPath $_.FullName -NewName $new_name
                    if($?) {
                        $ChangeCount++
                    }
                }
            }
        }
    }
    End {
        Write-Host "Number of changed files: $($ChangeCount)" -ForegroundColor Cyan
    }
}

# remove suffix from filename
function Remove-Suffix {
    param(
        [string] $Path,
        [string] $Suffix
    )
    Begin {
        if([string]::IsNullOrEmpty($Path)) { $Path = Read-Host -Prompt "What folder do you want to remove the suffix from all files?"}
        if([string]::IsNullOrEmpty($Suffix)) { $Suffix = Read-Host -Prompt "What suffix do you want to remove from all files in this folder?"}
        $valid_params = $(Test-Params $Path $Suffix)
    }

    Process {
        if($valid_params) {
            Write-Host "Removing Suffix: $($Suffix)" -ForegroundColor Green
            Write-Host "Files in folder: $((Get-ChildItem $Path | Measure-Object).Count)" -ForegroundColor Cyan
            $ChangeCount = 0
            Get-ChildItem $Path | ForEach-Object {
                $org_name = [io.path]::GetFileNameWithoutExtension($_.FullName)
                # only remove suffix if filename has it
                if($("$($org_name)$($_.Extension)" -Match "$($Suffix)$($_.Extension)")) {
                    $new_name =  "$("$($org_name)$($_.Extension)" -replace "$($Suffix)$($_.Extension)", "$($_.Extension)")"
                    Write-Host $new_name
                    Rename-Item -LiteralPath $_.FullName -NewName $new_name
                    if($?) {
                        $ChangeCount++
                    }
                }
            }
        }
    }
    End {
        Write-Host "Number of changed files: $($ChangeCount)" -ForegroundColor Cyan
    }
}

# Export Functions
Export-ModuleMember -Function Add-Suffix
Export-ModuleMember -Function Remove-Suffix