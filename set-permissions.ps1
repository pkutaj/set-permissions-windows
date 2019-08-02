<# -/-/-/-/-/-/-/-/   R E A D M E   -/-/-/-/-/-/-/-/-/-/-/-/-/-

PURPOSE
    To set the access rights to a given user, but without any inheritance 

TOC
    STEP  | ACTION
    ------|-------
    #1    | DEFINE VISUALS
    #2    | DEFINE MANDATORY PARAMETERS
    #2.1  |  GET PATH
    #2.2  |  GET SECURITY GROUP
    #3    | ASSIGN PERMISSIONS
    #4    | CALL THE FUNCTION WITH THE ENDLESS LOOP
    
    CREATED
    Brno, GITC, 2019-07-26
    #>    
<#-/-/-/-/-/-/-/-/   C O D E   -/-/-/-/-/-/-/-/-/-/-/-/-/-/-#>
    
#1    | DEFINE VISUALS, FOLD FOR THE READIBILITY OF CODE
$intro = @"

 / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \_
/ /  \ \____/ /  \ \____/ /  \ \____/ /  \ \____/ /  \ \____/ /  \ \__
\ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / _
 \____/ /  \ \____/ /                                _/ /  \ \____/ / 
 / __ \ \__/ / __ \ \_   FOLDER PERMISSION SETTER     \ \__/ / __ \ \_
/ /  \ \____/ /  \ \__   POPULATE THE PARAMETERS     \ \____/ /  \ \__
\ \__/ / __ \ \__/ / _   ... OR LEAVE EMPTY TO QUIT  / / __ \ \__/ / _
 \____/ /  \ \____/ /                                _/ /  \ \____/ / 
 / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \_
/ /  \ \____/ /  \ \____/ /  \ \____/ /  \ \____/ /  \ \____/ /  \ \__
\ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / _
 \____/ /  \ \____/ /  \ \____/ /  \ \____/ /  \ \____/ /  \ \____/ / 
 / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \_

"@

$outro = @"

 / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \_
/ /  \ \____/ /  \ \____                      __/ /  \ \____/ /  \ \__
\ \__/ / __ \ \__/ / __         BYE-BYE       _ \ \__/ / __ \ \__/ / _
 \____/ /  \ \____/ /  \                       \ \____/ /  \ \____/ / 
 / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \_

"@

$errorMessage = @"

 / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \_
/ /  \ \____/ /  \ \___                         / /  \ \____/ /  \ \__
\ \__/ / __ \ \__/ / __  CHECK ERRORS AND RETRY \ \__/ / __ \ \__/ / _
 \____/ /  \ \____/ /  \                         \____/ /  \ \____/ / 
 / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \__/ / __ \ \_

"@

#1 DEFINE MANDATORY PARAM WITHIN THE FUNCTION
function Set_folder_permission {
    param (
        #1.1 GET PATH
        [Parameter (Mandatory = $true)][AllowEmptyString()][string]$file_path,
        #1.2 GET SECURITY GROUP
        [Parameter (Mandatory = $true)][AllowEmptyString()][string]$AD_security_group
    )

    If ($file_path -eq "") {
        cls
        Write-Host $outro -ForegroundColor Cyan
        pause
        exit
    }

    $rights_assigned = @"
  ____     
 / __ \  
/ /  \ \ MODIFY ACCESS                             
\ \__/ / WAS GRANTED                                                                      
 \____/  

 Group: $AD_security_group
 Path: $file_path 

"@

    #2 Assign the permission
    try {
        $domain = Get-ADDomain
        $AD_security_group = $domain.name + '\' + $AD_security_group
        $Acl = Get-Acl $file_Path
        $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($AD_security_group, 'Modify', 'None', 'None', 'Allow')
        $Acl.SetAccessRule($accessRule)
        Set-Acl $file_Path $Acl
        Write-Host $rights_assigned -ForegroundColor Cyan
        Pause
        CLS
    }
    catch { 
        Write-Host $errorMessage -ForegroundColor Cyan 
        Pause
    }
}

#3    | Call the function
Write-Host $intro -ForegroundColor Cyan
pause
CLS
While ($true) {  
    Set_folder_permission
}