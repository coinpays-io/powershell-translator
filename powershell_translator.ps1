$targetDirectory = "[your_project_path]"
$outputFile = "results.txt"

$uniqueTexts = New-Object System.Collections.Generic.HashSet[string]
$files = Get-ChildItem -Path $targetDirectory -Recurse -Include *.php,*.blade.php | Where-Object { $_.FullName -notlike "*\vendor\*" }

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    $matches = [Regex]::Matches($content, "Translation::convert\('(.+?)'\)")
    foreach ($match in $matches) {
        $extractedText = $match.Groups[1].Value
        if ($uniqueTexts.Add($extractedText)) {
            Add-Content -Path $outputFile -Value $extractedText
        }
    }
}

Write-Host "Success!"
