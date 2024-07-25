<#	Split-Textfile.ps1 - Adam Lewis - March 2024
	
	.SYNOPSIS
	Reads in a large text file and splits it into smaller files
	
	.DESCRIPTION
	Reads in a large text file and splits it into smaller files.
	From https://stackoverflow.com/questions/1001776/how-can-i-split-a-text-file-using-powershell

#>

Write-Host " Fully qualified path to working directory that contains source file (C:\Temp). " -ForegroundColor "Cyan"
Write-Host " No trailing slash. Snippets will be generated here." -ForegroundColor "Cyan"
$WorkingDirName = Read-Host "`tPath"

Write-Host " Fully qualified source file name. (myfile.txt)" -ForegroundColor "Cyan"
$SourceFileName = Read-Host "`tSource File"

Write-Host " Suffix of snippet file names (log, txt, etc)" -ForegroundColor "Cyan"
$ext = Read-Host "`tSuffix"

Write-Host " Snippet file size in KB" -ForegroundColor "Cyan"
$upperBound = Read-Host "`tFile Size"
$upperBound = $upperBound+"KB"

$SourceFilePath = $WorkingDirName+"\"+$SourceFileName
$SourceFile = Get-Item $SourceFilePath

$rootName = Split-Path $SourceFile -LeafBase

$fromFile = [io.file]::OpenRead($SourceFilePath)
$buff = new-object byte[] $upperBound
$count = $idx = 0

try {
    do {
        "Reading $upperBound"
        $count = $fromFile.Read($buff, 0, $buff.Length)
        if ($count -gt 0) {
            $to = "{0}\{1}.chunk.{2}.{3}" -f ($WorkingDirName, $rootName, $idx, $ext)
            $toFile = [io.file]::OpenWrite($to)
            try {
                "Writing $count to $to"
                $tofile.Write($buff, 0, $count)
            } finally {
                $tofile.Close()
            }
        }
        $idx ++
    } while ($count -gt 0)
}
finally {
    $fromFile.Close()
}