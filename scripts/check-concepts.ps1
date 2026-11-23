# check-concepts.ps1 - Automated validator for concept pages in wiki/concepts
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$errors = [System.Collections.Generic.List[string]]::new()
$dir = Join-Path $PSScriptRoot "..\wiki\concepts"
$files = Get-ChildItem -Path $dir -Filter "*.md"
$registryText = [System.IO.File]::ReadAllText((Join-Path $PSScriptRoot "..\raw\sources\registry.md"), [System.Text.Encoding]::UTF8)

$charSlugs = [System.Collections.Generic.HashSet[string]]::new()
$charFiles = Get-ChildItem -Path (Join-Path $PSScriptRoot "..\wiki\characters") -Filter "*.md"
foreach ($cf in $charFiles) { [void]$charSlugs.Add($cf.BaseName) }

$allConceptSlugs = [System.Collections.Generic.HashSet[string]]::new()
foreach ($f in $files) { [void]$allConceptSlugs.Add($f.BaseName) }

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    if ($content -notmatch '(?s)^---\s*\r?\n(.*?)\r?\n---(?:\r?\n|$)') {
        $errors.Add("$($file.Name): 缺少 YAML frontmatter")
        continue
    }
    $yamlText = $matches[1]
    
    $title = if ($yamlText -match '(?m)^title:\s*"(.*)"\s*$') { $matches[1] } elseif ($yamlText -match '(?m)^title:\s*(.*)\s*$') { $matches[1] } else { $null }
    $slug = if ($yamlText -match '(?m)^slug:\s*"(.*)"\s*$') { $matches[1] } elseif ($yamlText -match '(?m)^slug:\s*(.*)\s*$') { $matches[1] } else { $null }
    $summary = if ($yamlText -match '(?m)^summary:\s*"(.*)"\s*$') { $matches[1] } elseif ($yamlText -match '(?m)^summary:\s*(.*)\s*$') { $matches[1] } else { $null }
    $updatedAt = if ($yamlText -match '(?m)^updatedAt:\s*"(.*)"\s*$') { $matches[1] } elseif ($yamlText -match '(?m)^updatedAt:\s*(.*)\s*$') { $matches[1] } else { $null }
    $status = if ($yamlText -match '(?m)^status:\s*"(.*)"\s*$') { $matches[1] } elseif ($yamlText -match '(?m)^status:\s*(.*)\s*$') { $matches[1] } else { $null }

    if ([string]::IsNullOrWhiteSpace($title)) { $errors.Add("$($file.Name): title 未填") }
    if ([string]::IsNullOrWhiteSpace($slug)) { $errors.Add("$($file.Name): slug 未填") }
    if ($file.Name -ne "$slug.md") { $errors.Add("$($file.Name): 檔名與 slug 不一致 ($slug)") }
    if ([string]::IsNullOrWhiteSpace($summary)) { $errors.Add("$($file.Name): summary 未填") }
    if ($updatedAt -notmatch '^\d{4}-\d{2}-\d{2}$') { $errors.Add("$($file.Name): updatedAt 格式錯誤 ($updatedAt)") }
    if ($status -notin @('draft', 'verified')) { $errors.Add("$($file.Name): status 必須為 draft 或 verified") }

    # Parse sourceIds
    if ($yamlText -match '(?ms)sourceIds:\s*\r?\n((?:\s*-\s*"?[A-Za-z0-9]+"?\s*\r?\n?)*)') {
        $sMatches = [regex]::Matches($matches[1], '-\s*"?([A-Za-z0-9]+)"?')
        foreach ($sm in $sMatches) {
            $sId = $sm.Groups[1].Value
            if ($registryText -notmatch [regex]::Escape($sId)) {
                $errors.Add("$($file.Name): sourceId $sId 未在 registry.md 中登記")
            }
        }
    }

    # Parse relatedConcepts
    if ($yamlText -match '(?ms)relatedConcepts:\s*\r?\n((?:\s*-\s*"?[a-z0-9-]+"?\s*\r?\n?)*)') {
        $cMatches = [regex]::Matches($matches[1], '-\s*"?([a-z0-9-]+)"?')
        foreach ($cm in $cMatches) {
            $cSlug = $cm.Groups[1].Value
            if (-not $allConceptSlugs.Contains($cSlug)) {
                $errors.Add("$($file.Name): relatedConcept '$cSlug' 不存在")
            }
        }
    }

    # Parse relatedCharacters
    if ($yamlText -match '(?ms)relatedCharacters:\s*\r?\n((?:\s*-\s*"?[a-z0-9-]+"?\s*\r?\n?)*)') {
        $chMatches = [regex]::Matches($matches[1], '-\s*"?([a-z0-9-]+)"?')
        foreach ($chm in $chMatches) {
            $chSlug = $chm.Groups[1].Value
            if (-not $charSlugs.Contains($chSlug)) {
                $errors.Add("$($file.Name): relatedCharacter '$chSlug' 不存在於 wiki/characters/")
            }
        }
    }

    # Required sections
    $reqSections = @('## 基本定義', '## 機制與例子', '## 常見誤解', '## 相關知識', '## 來源與限制', '## 待查證')
    foreach ($sec in $reqSections) {
        if ($content -notmatch [regex]::Escape($sec)) {
            $errors.Add("$($file.Name): 缺少必要章節 '$sec'")
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host "✗ 概念頁檢查失敗，共 $($errors.Count) 項：" -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host "  - $err" -ForegroundColor Red
    }
    exit 1
} else {
    Write-Host "✓ 概念頁檢查通過：$($files.Count) 篇概念；Frontmatter、來源、關聯概念、角色與必要章節全數正確。" -ForegroundColor Green
    exit 0
}
