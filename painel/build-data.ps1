<#
.SYNOPSIS
  Atualiza os dados do painel geral de propostas.

.DESCRIPTION
  Varre os meta.json das propostas atuais, soma as entradas manuais de
  legacy.json e grava data.js. A página painel/index.html consome esse arquivo
  diretamente, sem API ou banco de dados.
#>

$ErrorActionPreference = 'Stop'
$panelDir = $PSScriptRoot
$repoDir = Split-Path $panelDir -Parent
$legacyPath = Join-Path $panelDir 'legacy.json'
$outputPath = Join-Path $panelDir 'data.js'

function Prettify-Slug([string]$slug) {
  return (($slug -split '-') | ForEach-Object {
    if ($_.Length -gt 0) { $_.Substring(0, 1).ToUpper() + $_.Substring(1) } else { $_ }
  }) -join ' '
}

$proposals = @()

Get-ChildItem -Path $repoDir -Recurse -Filter 'meta.json' -File | ForEach-Object {
  if ($_.FullName.StartsWith($panelDir, [System.StringComparison]::OrdinalIgnoreCase)) { return }

  try {
    $meta = Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
  } catch {
    Write-Warning "Meta ignorado por JSON inválido: $($_.FullName)"
    return
  }

  $projectDir = $_.Directory
  $relativeDir = $projectDir.FullName.Substring($repoDir.Length).TrimStart('\')
  $parts = $relativeDir -split '\\'
  if ($parts.Count -lt 2) { return }

  $clientSlug = $parts[0]
  $projectSlug = ($parts[1..($parts.Count - 1)] -join '/')
  $clientName = if ($meta.cliente) { [string]$meta.cliente } else { Prettify-Slug $clientSlug }

  $proposals += [pscustomobject]@{
    id            = "$clientSlug-$($projectSlug -replace '/', '-')"
    cliente       = $clientName
    titulo        = [string]$meta.titulo
    subtitulo     = [string]$meta.subtitulo
    data          = [string]$meta.data
    status        = if ($meta.status) { [string]$meta.status } else { 'Sem status' }
    investimento  = if ($meta.investimento) { [string]$meta.investimento } else { '—' }
    tipo          = if ($meta.tipo) { [string]$meta.tipo } else { '' }
    observacao    = if ($meta.observacao) { [string]$meta.observacao } else { '' }
    href          = "../$clientSlug/$projectSlug/"
  }
}

if (Test-Path $legacyPath) {
  $legacy = Get-Content -LiteralPath $legacyPath -Raw -Encoding UTF8 | ConvertFrom-Json
  foreach ($item in @($legacy)) { $proposals += $item }
}

$proposals = @($proposals | Sort-Object -Property @{ Expression = 'data'; Descending = $true }, @{ Expression = 'cliente' }, @{ Expression = 'titulo' })
$json = $proposals | ConvertTo-Json -Depth 6
$payload = "window.PROPOSTAS = $json;`n"
[System.IO.File]::WriteAllText($outputPath, $payload, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "OK  Painel atualizado: painel\data.js ($($proposals.Count) proposta(s))" -ForegroundColor Green
