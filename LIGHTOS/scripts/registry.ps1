param(

    [Parameter(Mandatory = $true)][ValidateSet("import", "backup")]
     [string]$type
)

function Is-Admin() {
    $current_principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $current_principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Apply-Registry($file_path) {
    if (!(Test-Path $file)) {
        return 1
    }

    $user_merge_result = (Start-Process "reg.exe" -ArgumentList "import $file_path" -PassThru -Wait -WindowStyle Hidden).ExitCode
    $trustedinstaller_merge_result = [int](C:\LIGHTOS\MinSudo.exe --NoLogo --TrustedInstaller --Privileged cmd /c "reg import $file_path > nul 2>&1 && echo 0 || echo 1")

   
}

function main() {
    if (-not (Is-Admin)) {
        Write-Host "error: administrator privileges required"
        return 1
    }

    $hasErrors = $false

    if($type -eq "import"){
    Write-Host "LIGHTOS: importing registry settings... "

	    foreach ($file in @("optimized-registry.reg")) {
		    $file = "C:\LIGHTOS\registry\$file"
        		    $file_name = $file.replace(".reg", "")
    		    $is_successful = 0

			if ($file_name.Contains("optimized-registry")) {
			  Apply-Registry -file_path $file		   
       			}

	   }

    Write-Host "$(if ($hasErrors) {"LIGHTOS: importing registry settings failed.."} else {"LIGHTOS: successfully imported registry settings.."})"
    return 0

    } elseif ($type -eq "backup"){
	Write-Host "LIGHTOS: this function is currently not working!"
               return 0
    }
 }

exit main




