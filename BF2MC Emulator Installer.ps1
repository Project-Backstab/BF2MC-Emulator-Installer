$iconUrl = "https://raw.githubusercontent.com/Project-Backstab/BF2MC-Emulator-Installer/main/images/bfmc_icon.ico"
$iconName = "bfmc_icon.ico"

$pcsx2Url = "https://github.com/PCSX2/pcsx2/releases/download/v1.7.3858/pcsx2-v1.7.3858-windows-64bit-AVX2-Qt.7z"
$pcsx2PackageName = "pcsx2-v1.7.3858-windows-64bit-AVX2-Qt.7z"

$zip7Url = "https://www.7-zip.org/a/7zr.exe"
$zip7ExeName = "7zr.exe"

$emulatorConfigUrl = "https://raw.githubusercontent.com/Project-Backstab/BF2MC-Emulator-Installer/main/inis/PCSX2.ini"
$emulatorConfigName = "PCSX2.ini"

$vulkanPatchUrl = "https://raw.githubusercontent.com/Project-Backstab/BF2MC-Emulator-Installer/main/resources/shaders/vulkan/tfx.glsl"
$vulkanPatchName = "tfx.glsl"

$memcardUrl = "https://raw.githubusercontent.com/Project-Backstab/BF2MC-Emulator-Installer/main/memcards/BFMCspy.ps2"
$memcardName = "BFMCspy.ps2"

Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'

[Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)
<# 
.NAME
    BF2MC Installer
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$MainWindow                      = New-Object system.Windows.Forms.Form
$MainWindow.ClientSize           = New-Object System.Drawing.Point(753,504)
$MainWindow.text                 = "BF2MC Online  |  Emulator Installer"
$MainWindow.TopMost              = $false
$MainWindow.SizeGripStyle        = [System.Windows.Forms.SizeGripStyle]::Hide
$MainWindow.StartPosition        = [System.Windows.Forms.FormStartPosition]::CenterScreen
$MainWindow.FormBorderStyle      = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$MainWindow.MaximizeBox          = $false
Invoke-WebRequest -Uri $iconUrl -OutFile "$iconName"
$MainWindow.icon                 = "bfmc_icon.ico"
Remove-Item -Path $iconName

$panelTop                        = New-Object system.Windows.Forms.Panel
$panelTop.height                 = 155
$panelTop.width                  = 734
$panelTop.location               = New-Object System.Drawing.Point(8,-57)
$panelTop.BackColor              = [System.Drawing.ColorTranslator]::FromHtml("#498d9f")

$pictureboxBF2MC                 = New-Object system.Windows.Forms.PictureBox
$pictureboxBF2MC.width           = 165
$pictureboxBF2MC.height          = 86
$pictureboxBF2MC.location        = New-Object System.Drawing.Point(17,3)
$pictureboxBF2MC.imageLocation   = "https://raw.githubusercontent.com/Project-Backstab/BF2MC-Emulator-Installer/main/images/bf2mc_online_logo.png"
$pictureboxBF2MC.SizeMode        = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$pictureboxBF2MC.BackColor       = [System.Drawing.ColorTranslator]::FromHtml("#498d9f")

$pictureboxBFMCspy               = New-Object system.Windows.Forms.PictureBox
$pictureboxBFMCspy.width         = 229
$pictureboxBFMCspy.height        = 86
$pictureboxBFMCspy.location      = New-Object System.Drawing.Point(233,3)
$pictureboxBFMCspy.imageLocation  = "https://raw.githubusercontent.com/Project-Backstab/BF2MC-Emulator-Installer/main/images/bfmcspy_logo.png"
$pictureboxBFMCspy.SizeMode      = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$pictureboxBFMCspy.BackColor     = [System.Drawing.ColorTranslator]::FromHtml("#498d9f")

$pictureboxPCSX2                 = New-Object system.Windows.Forms.PictureBox
$pictureboxPCSX2.width           = 229
$pictureboxPCSX2.height          = 86
$pictureboxPCSX2.location        = New-Object System.Drawing.Point(501,3)
$pictureboxPCSX2.imageLocation   = "https://raw.githubusercontent.com/Project-Backstab/BF2MC-Emulator-Installer/main/images/pcsx2_logo.png"
$pictureboxPCSX2.SizeMode        = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$pictureboxPCSX2.BackColor       = [System.Drawing.ColorTranslator]::FromHtml("#498d9f")

$textboxInstallDir               = New-Object system.Windows.Forms.TextBox
$textboxInstallDir.multiline     = $false
$textboxInstallDir.text          = [System.IO.Path]::Combine([Environment]::GetFolderPath('MyDocuments'))
$textboxInstallDir.width         = 229
$textboxInstallDir.height        = 20
$textboxInstallDir.location      = New-Object System.Drawing.Point(158,200)
$textboxInstallDir.Font          = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$tooltipInstallDir               = New-Object system.Windows.Forms.ToolTip
$tooltipInstallDir.ToolTipTitle  = "asdasd"
$tooltipInstallDir.SetToolTip($textboxInstallDir,'Test')

$buttonInstallDirSelect          = New-Object system.Windows.Forms.PictureBox
$buttonInstallDirSelect.width    = 69
$buttonInstallDirSelect.height   = 43
$buttonInstallDirSelect.location  = New-Object System.Drawing.Point(446,200)
$buttonInstallDirSelect.imageLocation  = "https://raw.githubusercontent.com/Project-Backstab/BF2MC-Emulator-Installer/main/images/folder_icon.png"
$buttonInstallDirSelect.SizeMode  = [System.Windows.Forms.PictureBoxSizeMode]::zoom

$buttonInstall                   = New-Object system.Windows.Forms.Button
$buttonInstall.text              = "Install"
$buttonInstall.width             = 162
$buttonInstall.height            = 44
$buttonInstall.visible           = $true
$buttonInstall.enabled           = $true
$buttonInstall.location          = New-Object System.Drawing.Point(547,402)
$buttonInstall.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$MainWindow.controls.AddRange(@(
    $pictureboxBF2MC,
    $pictureboxBFMCspy,
    $pictureboxPCSX2,
    $textboxInstallDir,
    $buttonInstallDirSelect,
    $buttonInstall,
    $panelTop
))

$buttonInstallDirSelect.Add_Click({ Get-FolderName  -Message "Select a poop." -ShowNewFolderButton $true -textBox $textboxInstallDir })
$buttonInstall.Add_Click({ Install-Everything })

#region Logic 
function Install-Everything {
    $buttonInstall.enabled = $false
    
    # Show console
    [Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 1)
    Clear-Host
    
    # Download 7zip-standalone
    $zip7FilePath = Join-Path $textboxInstallDir.text $zip7ExeName
    Write-Host "Downloading dependencies..."
    # Invoke-WebRequest -Uri $zip7Url -OutFile $zip7FilePath
    
    # Download the PCSX2 .7z file
    $pcsx2FilePath = Join-Path $textboxInstallDir.text $pcsx2PackageName
    Clear-Host
    Write-Host "Downloading PCSX2 v1.7.3858 emulator..."
    # Invoke-WebRequest -Uri $pcsx2Url -OutFile $pcsx2FilePath
    
    # Extract PCSX2
    Clear-Host
    Write-Host "Unpacking PCSX2 emulator..."
    $pcsx2InstallPath = Join-Path $textboxInstallDir.text "PCSX2-v1.7.3858"
    # & $zip7FilePath x $pcsx2FilePath -o"$pcsx2InstallPath"
    Remove-Item -Path $zip7FilePath
    Remove-Item -Path $pcsx2FilePath
    Write-Host "Unpacking completed."
    Start-Sleep -Seconds 1

    # Download emulator config
    Clear-Host
    Write-Host "Downloading emulator config..."
    $inisPath = Join-Path $pcsx2InstallPath "inis"
    New-Item -ItemType Directory -Path $inisPath
    $gamesPath = Join-Path $pcsx2InstallPath "games"
    New-Item -ItemType Directory -Path $gamesPath
    $configPath = Join-Path $inisPath $emulatorConfigName
    Invoke-WebRequest -Uri $emulatorConfigUrl -OutFile $configPath
    (Get-Content -Path $configPath -Raw) -replace "GAMES_PATH", $gamesPath | Set-Content -Path $configPath

    # Download Vulkan renderer patch
    Clear-Host
    Write-Host "Downloading Vulkan renderer patch..."
    $vulkanPath = Join-Path $pcsx2InstallPath "resources\shaders\vulkan"
    $vulkanPath = Join-Path $vulkanPath $vulkanPatchName
    Invoke-WebRequest -Uri $vulkanPatchUrl -OutFile $vulkanPath

    # Download memcard
    Clear-Host
    Write-Host "Downloading pre-configured PS2 memory card (for connection to BFMCspy)..."
    $memcardsPath = Join-Path $pcsx2InstallPath "memcards"
    New-Item -ItemType Directory -Path $memcardsPath
    $memcardPath = Join-Path $memcardsPath $memcardName
    Invoke-WebRequest -Uri $memcardUrl -OutFile $memcardPath
    
    # Hide console
    [Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)
}

function Get-FolderName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [string]$Message = "Select a directory.",

        [bool]$ShowNewFolderButton = $false,
        
        [system.Windows.Forms.TextBox]$textBox = $null
    )

    $browserForFolderOptions = 0x00000041                                  # BIF_RETURNONLYFSDIRS -bor BIF_NEWDIALOGSTYLE
    if (!$ShowNewFolderButton) { $browserForFolderOptions += 0x00000200 }  # BIF_NONEWFOLDERBUTTON

    $browser = New-Object -ComObject Shell.Application
    # To make the dialog topmost, you need to supply the Window handle of the current process
    [intPtr]$handle = [System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle

    # see: https://msdn.microsoft.com/en-us/library/windows/desktop/bb773205(v=vs.85).aspx
    $folder = $browser.BrowseForFolder($handle, $Message, $browserForFolderOptions)

    $result = $null
    if ($folder) {
        $result = $folder.Self.Path
    }

    # Release and remove the used Com object from memory
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($browser) | Out-Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()

    $textBox.text = $result
}

#endregion

[void]$MainWindow.ShowDialog()