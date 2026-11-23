# check-data.ps1 - PowerShell validator mirroring check-data.mjs for offline testing
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$dir = Join-Path $PSScriptRoot "..\wiki\characters"
$files = Get-ChildItem -Path $dir -Filter "*.md"
$errors = [System.Collections.Generic.List[string]]::new()
$entities = @{}
$validElements = @('火','水','雷','冰','風','岩','草')
$validWeapons = @('單手劍','雙手劍','長柄武器','法器','弓')

function Test-DateValid($val) {
    if ($val -isnot [string]) { return $false }
    if ($val -notmatch '^\d{4}-\d{2}-\d{2}$') { return $false }
    $parsed = [DateTime]::MinValue
    return [DateTime]::TryParseExact($val, 'yyyy-MM-dd', [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::None, [ref]$parsed)
}

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    if ($content -notmatch '(?s)^---\s*\r?\n(.*?)\r?\n---(?:\r?\n|$)') {
        $errors.Add("$($file.Name): 缺少 YAML frontmatter")
        continue
    }
    $yamlText = $matches[1]
    
    # Parse YAML fields simply or regex-based
    $name = if ($yamlText -match '(?m)^name:\s*"(.*)"\s*$') { $matches[1] } elseif ($yamlText -match '(?m)^name:\s*(.*)\s*$') { $matches[1] } else { $null }
    $slug = if ($yamlText -match '(?m)^slug:\s*"(.*)"\s*$') { $matches[1] } elseif ($yamlText -match '(?m)^slug:\s*(.*)\s*$') { $matches[1] } else { $null }
    $rarity = if ($yamlText -match '(?m)^rarity:\s*(\d+)\s*$') { [int]$matches[1] } else { $null }
    $element = if ($yamlText -match '(?m)^element:\s*"(.*)"\s*$') { $matches[1] } elseif ($yamlText -match '(?m)^element:\s*(.*)\s*$') { $matches[1] } else { $null }
    $weapon = if ($yamlText -match '(?m)^weapon:\s*"(.*)"\s*$') { $matches[1] } elseif ($yamlText -match '(?m)^weapon:\s*(.*)\s*$') { $matches[1] } else { $null }
    $region = if ($yamlText -match '(?m)^region:\s*"(.*)"\s*$') { $matches[1] } elseif ($yamlText -match '(?m)^region:\s*(.*)\s*$') { $matches[1] } else { $null }
    $tagline = if ($yamlText -match '(?m)^tagline:\s*"(.*)"\s*$') { $matches[1] } elseif ($yamlText -match '(?m)^tagline:\s*(.*)\s*$') { $matches[1] } else { $null }
    $summary = if ($yamlText -match '(?m)^summary:\s*"(.*)"\s*$') { $matches[1] } elseif ($yamlText -match '(?m)^summary:\s*(.*)\s*$') { $matches[1] } else { $null }
    $updatedAt = if ($yamlText -match '(?m)^updatedAt:\s*"(.*)"\s*$') { $matches[1] } elseif ($yamlText -match '(?m)^updatedAt:\s*(.*)\s*$') { $matches[1] } else { $null }
    $status = if ($yamlText -match '(?m)^status:\s*"(.*)"\s*$') { $matches[1] } elseif ($yamlText -match '(?m)^status:\s*(.*)\s*$') { $matches[1] } else { $null }
    $spoilers = if ($yamlText -match '(?m)^spoilers:\s*(true|false)\s*$') { [bool]::Parse($matches[1]) } else { $null }

    # Parse relations
    $relations = @()
    if ($yamlText -match '(?ms)relations:\s*\r?\n((?:\s*-\s*slug:.*?(?=\r?\n\w|\z))*)') {
        $relBlock = $matches[1]
        $relMatches = [regex]::Matches($relBlock, '(?ms)-\s*slug:\s*"?([^"\r\n]+)"?\s*\r?\n\s*label:\s*"?([^"\r\n]+)"?')
        foreach ($rm in $relMatches) {
            $relations += ,@{ slug = $rm.Groups[1].Value.Trim(); label = $rm.Groups[2].Value.Trim() }
        }
    } elseif ($yamlText -match '(?m)^relations:\s*\[\s*\]\s*$') {
        $relations = @()
    }

    # Parse sources
    $sources = @()
    if ($yamlText -match '(?ms)sources:\s*\r?\n((?:\s*-\s*title:.*?(?=\r?\n\w|\z))*)') {
        $srcBlock = $matches[1]
        $srcMatches = [regex]::Matches($srcBlock, '(?ms)-\s*title:\s*"?([^"\r\n]+)"?\s*\r?\n\s*url:\s*"?([^"\r\n]+)"?\s*\r?\n\s*checkedAt:\s*"?([^"\r\n]+)"?')
        foreach ($sm in $srcMatches) {
            $sources += ,@{
                title = $sm.Groups[1].Value.Trim()
                url = $sm.Groups[2].Value.Trim()
                checkedAt = $sm.Groups[3].Value.Trim()
            }
        }
    }

    $d = @{
        file = $file.Name
        name = $name
        slug = $slug
        rarity = $rarity
        element = $element
        weapon = $weapon
        region = $region
        tagline = $tagline
        summary = $summary
        updatedAt = $updatedAt
        status = $status
        spoilers = $spoilers
        relations = $relations
        sources = $sources
    }

    $required = @('name','slug','rarity','element','weapon','region','tagline','summary','updatedAt','status','spoilers','relations','sources')
    foreach ($k in $required) {
        if ($d[$k] -eq $null -or ($d[$k] -is [string] -and [string]::IsNullOrWhiteSpace($d[$k]))) {
            $errors.Add("$($file.Name): 欄位 $k 未填")
        }
    }

    if ($slug -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') { $errors.Add("$($file.Name): slug 格式錯誤") }
    if ($file.Name -ne "$slug.md") { $errors.Add("$($file.Name): 檔名必須與 slug 一致") }
    if ($entities.ContainsKey($slug)) { $errors.Add("$($file.Name): slug 重複") }
    $entities[$slug] = $d

    if ($rarity -notin @(4, 5)) { $errors.Add("$($file.Name): rarity 必須是 4 或 5") }
    if ($element -notin $validElements) { $errors.Add("$($file.Name): element 無效 ($element)") }
    if ($weapon -notin $validWeapons) { $errors.Add("$($file.Name): weapon 無效 ($weapon)") }
    if ($status -notin @('draft', 'verified')) { $errors.Add("$($file.Name): status 必須 draft/verified") }
    if ($spoilers -isnot [bool]) { $errors.Add("$($file.Name): spoilers 必須布林值") }
    if (-not (Test-DateValid $updatedAt)) { $errors.Add("$($file.Name): updatedAt 日期格式錯誤") }
    if ($sources.Count -lt 1) { $errors.Add("$($file.Name): 至少一個來源") }

    foreach ($s in $sources) {
        if ([string]::IsNullOrWhiteSpace($s.title)) { $errors.Add("$($file.Name): source.title 不可空白") }
        $validUri = $false
        try {
            $uri = [System.Uri]::new($s.url)
            if ($uri.Scheme -in @('http', 'https')) { $validUri = $true }
        } catch {}
        if (-not $validUri) { $errors.Add("$($file.Name): 無效來源網址 $($s.url)") }
        if (-not (Test-DateValid $s.checkedAt)) { $errors.Add("$($file.Name): source.checkedAt 日期格式錯誤") }
    }
}

foreach ($slug in $entities.Keys) {
    $d = $entities[$slug]
    $relations = $d.relations
    $seen = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($r in $relations) {
        if (-not $r.slug -or -not $r.label) {
            $errors.Add("${slug}: relation 缺少 slug 或 label")
            continue
        }
        if ($r.slug -eq $slug) { $errors.Add("${slug}: 不能連結自己") }
        if ($seen.Contains($r.slug)) { $errors.Add("${slug}: 關聯重複 $($r.slug)") }
        [void]$seen.Add($r.slug)
        if (-not $entities.ContainsKey($r.slug)) {
            $errors.Add("${slug}: 連結不存在角色 $($r.slug)")
        } else {
            $targetRel = $entities[$r.slug].relations
            $hasBacklink = $false
            foreach ($tr in $targetRel) {
                if ($tr.slug -eq $slug) { $hasBacklink = $true; break }
            }
            if (-not $hasBacklink) {
                $errors.Add("${slug}: $($r.slug) 缺少回連（本專案關聯要求雙向）")
            }
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host "✗ Wiki 檢查失敗，共 $($errors.Count) 項：" -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host "  - $err" -ForegroundColor Red
    }
    exit 1
} else {
    Write-Host "✓ Wiki 資料檢查通過：$($files.Count) 名角色；slug、欄位、來源及雙向關聯正確。" -ForegroundColor Green
    exit 0
}
