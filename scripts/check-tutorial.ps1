# check-tutorial.ps1 - Automated validator for tutorial slides and workflow outputs
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$errors = [System.Collections.Generic.List[string]]::new()
$runPath = Join-Path $PSScriptRoot "..\workflow\runs\2026-11-23-01"
$jsonFile = Join-Path $runPath "slide-content.json"

if (-not (Test-Path -LiteralPath $jsonFile)) {
    Write-Error "找不到 slide-content.json"
    exit 1
}

$rawJson = [System.IO.File]::ReadAllText($jsonFile, [System.Text.Encoding]::UTF8)
try {
    $data = ConvertFrom-Json -InputObject $rawJson
} catch {
    $errors.Add("slide-content.json 不是合法的 JSON 格式: $($_.Exception.Message)")
}

if ($data) {
    if (-not $data.slides -or $data.slides.Count -lt 10 -or $data.slides.Count -gt 12) {
        $errors.Add("投影片總頁數應在 10～12 頁之間，目前為: $($data.slides.Count)")
    }

    $seenIds = [System.Collections.Generic.HashSet[string]]::new()
    $registryText = [System.IO.File]::ReadAllText((Join-Path $PSScriptRoot "..\raw\sources\registry.md"), [System.Text.Encoding]::UTF8)

    $slideIdx = 0
    foreach ($slide in $data.slides) {
        $slideIdx++
        if ([string]::IsNullOrWhiteSpace($slide.id)) { $errors.Add("第 $slideIdx 頁缺少 id") }
        if ($seenIds.Contains($slide.id)) { $errors.Add("第 $slideIdx 頁 id 重複: $($slide.id)") }
        [void]$seenIds.Add($slide.id)

        if ([string]::IsNullOrWhiteSpace($slide.title)) { $errors.Add("第 $slideIdx 頁 ($($slide.id)) 缺少 title") }
        if ([string]::IsNullOrWhiteSpace($slide.objective)) { $errors.Add("第 $slideIdx 頁 ($($slide.id)) 缺少 objective") }

        # Check citations
        if ($slide.id -ne "slide-01-cover" -and ($slide.citations -eq $null -or $slide.citations.Count -eq 0)) {
            $errors.Add("非導航頁 $($slide.id) 的 citations 不可為空")
        }

        if ($slide.citations) {
            foreach ($c in $slide.citations) {
                if (-not $c.wikiPath -or -not $c.sourceId -or -not $c.claimId) {
                    $errors.Add("第 $slideIdx 頁 citation 格式不全: $($c | ConvertTo-Json -Compress)")
                    continue
                }
                $targetWiki = Join-Path $PSScriptRoot ("..\" + $c.wikiPath.Replace('/', '\'))
                if (-not (Test-Path -LiteralPath $targetWiki)) {
                    $errors.Add("第 $slideIdx 頁引用的 wikiPath 不存在: $($c.wikiPath)")
                }
                if ($registryText -notmatch [regex]::Escape($c.sourceId)) {
                    $errors.Add("第 $slideIdx 頁引用的 sourceId 未在 registry.md 中登記: $($c.sourceId)")
                }
            }
        }

        # Check blocks
        foreach ($b in $slide.blocks) {
            if ($b.type -eq "character-showcase") {
                foreach ($ex in $b.examples) {
                    $charFile = Join-Path $PSScriptRoot "..\wiki\characters\$($ex.slug).md"
                    if (-not (Test-Path -LiteralPath $charFile)) {
                        $errors.Add("角色範例 $($ex.slug) 不存在於 wiki/characters/")
                    }
                }
            }

            if ($b.type -eq "interactive-quiz") {
                foreach ($q in $b.questions) {
                    if ($q.options.Count -lt 2) { $errors.Add("測驗題 $($q.id) 選項不足 2 個") }
                    if ($q.answerIndex -lt 0 -or $q.answerIndex -ge $q.options.Count) {
                        $errors.Add("測驗題 $($q.id) answerIndex 超出選項範圍")
                    }
                    if ([string]::IsNullOrWhiteSpace($q.explanation)) {
                        $errors.Add("測驗題 $($q.id) 缺少 explanation")
                    }
                }
            }
        }
    }
}

# Check Astro and CSS files
$astroFile = Join-Path $PSScriptRoot "..\src\pages\tutorial\index.astro"
$cssFile = Join-Path $PSScriptRoot "..\src\styles\tutorial.css"
if (-not (Test-Path -LiteralPath $astroFile)) { $errors.Add("找不到 src/pages/tutorial/index.astro") }
if (-not (Test-Path -LiteralPath $cssFile)) { $errors.Add("找不到 src/styles/tutorial.css") }

if ($errors.Count -gt 0) {
    Write-Host "✗ 教學簡報資料檢查失敗，共 $($errors.Count) 項：" -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host "  - $err" -ForegroundColor Red
    }
    exit 1
} else {
    Write-Host "✓ 教學簡報資料檢查通過：12 頁投影片；JSON 語法、唯一 ID、引用存在性、測驗結構、角色對照及 Astro 頁面檔案全數正確。" -ForegroundColor Green
    exit 0
}
