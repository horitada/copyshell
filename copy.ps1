
$DebugPreference = "Continue"
$path = 'C:\xampp\htdocs\NetCommons-2.4.2.1\html\webapp\modules' #対象のルートディレクトリパス
$before = 'announcement' #コピー対象モジュール
$after = 'copymodule' #置換文字列小文字で指定してください
$beforePath = $path + '\' + $before
$afterPath = $path + '\' + $after
$reg = '*' + $before + '*'
$upBefore = $before.SubString(0,1).ToUpper() + $before.SubString(1, $before.Length - 1)
$upAfter = $after.SubString(0,1).ToUpper() + $after.SubString(1, $after.Length - 1)

Copy-Item -Path $beforePath -Destination $afterPath -Recurse #コピー
cd $afterPath

#Write-Debug "afterPath: $afterPath"

Get-ChildItem -include $reg -r | rename-item -newname { $_.name -creplace $before, $after}
Get-ChildItem -include $reg -r | rename-item -newname { $_.name -creplace $upBefore, $upAfter}

$reg = '.*' + $before + '*'
Get-ChildItem -r | ? { Select-String -InputObject $_ -Pattern $reg } | %{ 
 $file = $_.FullName
 $content = Get-Content -LiteralPath $file -Encoding UTF8
 Set-Content $_.FullName ($content -creplace $before, $after) -Encoding UTF8
 [System.IO.File]::WriteAllLines($_.FullName, ( Get-Content $_.FullName ), ( New-Object System.Text.UTF8Encoding($false) ))
}

Get-ChildItem -r | ? { Select-String -InputObject $_ -Pattern $reg } | %{ 
 $file = $_.FullName
 $content = Get-Content -LiteralPath $file -Encoding UTF8
 Set-Content $_.FullName ($content -creplace $upBefore, $upAfter) -Encoding UTF8
 [System.IO.File]::WriteAllLines($_.FullName, ( Get-Content $_.FullName ), ( New-Object System.Text.UTF8Encoding($false) ))
}

cd C:\Users\ccm_horiguchi\Desktop\test


