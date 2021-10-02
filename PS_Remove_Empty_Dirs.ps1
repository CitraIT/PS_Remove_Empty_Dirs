<#
# CITRA IT - EXCELÊNCIA EM TI
# SCRIPT PARA REMOVER PASTAS/SUBPASTAS VAZIAS
# AUTOR: luciano@citrait.com.br
# DATA: 01/10/2021
# EXAMPLO DE USO: Powershell -ExecutionPolicy ByPass -File C:\scripts\PS_Remove_Empty_Dirs.ps1 -lookupdir E:\Shared\Engineering\Projects
#>

Param(
	[Parameter(Mandatory=$True)] [string] $lookupdir
)


# ----------------------------------------------------------------------------------------------------------
# Function IsEmpty()
# @argument: [System.IO.DirectoryInfo] $dir = Current directory to evaluate.
# @returns: $true if the directory has no files and no folders, $false if it has any file or subfolder.
# ----------------------------------------------------------------------------------------------------------
Function IsEmptyDir([System.IO.DirectoryInfo] $dir)
{
	If($dir.GetDirectories().count -eq 0 -and $dir.GetFiles().count -eq 0)
	{
		Return $True
	}else{
		Return $False
	}
}



# ----------------------------------------------------------------------------------------------------------
# Function SearchEmptyDir()
# @argument: [System.IO.DirectoryInfo] $dir = Current directory to look if its empty.
# ----------------------------------------------------------------------------------------------------------
Function SearchEmptyDir([System.IO.DirectoryInfo] $dir)
{
	#Write-Host "Entrando na pasta $($dir.fullname)"
	$directories = $dir.GetDirectories()
	
	# Se a pasta atual tiver subpastas, procura por arquivos nas subpastas.
	If($directories.count -gt 0)
	{
		#Write-Host "A pasta $($dir.name) tem subpastas"
		# Ha subdiretorios
		ForEach($subdir in $directories)
		{
			#Write-Host "Verificando pasta $($subdir.FullName)"
			# Se a subpasta tiver vazio: deletar
			If(IsEmptyDir($subdir))
			{
				Write-Host "Removendo pasta vazia $($subdir.fullname)"
				Remove-Item -Path $subdir.FullName -Force -ErrorAction Stop -Confirm:$false
			}else{
				SearchEmptyDir($subdir)
			}
			
		}
	}
	
	# Processou todas as subapstas desta pasta, agora rever se ela ficou vazia após processamento.
	If(IsEmptyDir($dir))
	{
		Write-Host "Removendo pasta vazia $($dir.fullname) vazia."
		Remove-Item -Path $dir.FullName -Force -ErrorAction Stop -Confirm:$false
	}
	
	
}






# ----------------------------------------------------------------------------------------------------------
#
# MAIN ROUTINE STARTS HERE
#
# ----------------------------------------------------------------------------------------------------------

Write-Host "Procurando por pastas vazias em: $lookupdir"
If(-Not (Test-Path $lookupdir))
{
	Write-Host -ForegroundColor RED "Erro ao encontrar a pasta $lookupdir"
	Exit
}

$search_dir = Get-Item -Path $lookupdir

SearchEmptyDir $search_dir
