$pcsx2Url = "https://github.com/PCSX2/pcsx2/releases/download/v1.7.3858/pcsx2-v1.7.3858-windows-64bit-AVX2-Qt.7z"
$pcsx2PackageName = "pcsx2-v1.7.3858-windows-64bit-AVX2-Qt.7z"

$zip7Url = "https://www.7-zip.org/a/7zr.exe"
$zip7ExeName = "7zr.exe"

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
$MainWindow.text                 = "BF2:MC Emulator Installer"
$MainWindow.TopMost              = $false
$MainWindow.SizeGripStyle        = [System.Windows.Forms.SizeGripStyle]::Hide
$MainWindow.StartPosition        = [System.Windows.Forms.FormStartPosition]::CenterScreen
$MainWindow.FormBorderStyle      = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$MainWindow.MaximizeBox          = $false
$MainWindow.ShowIcon             = "https://raw.githubusercontent.com/Project-Backstab/BF2MC-Emulator-Installer/main/icons/bfmc_icon.png"

$textboxInstallDir               = New-Object system.Windows.Forms.TextBox
$textboxInstallDir.multiline     = $false
$textboxInstallDir.text          = "Test"
$textboxInstallDir.width         = 229
$textboxInstallDir.height        = 20
$textboxInstallDir.location      = New-Object System.Drawing.Point(158,52)
$textboxInstallDir.Font          = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$buttonInstallDirSelect          = New-Object system.Windows.Forms.PictureBox
$buttonInstallDirSelect.width    = 69
$buttonInstallDirSelect.height   = 43
$buttonInstallDirSelect.location  = New-Object System.Drawing.Point(446,45)
$buttonInstallDirSelect.imageLocation  = "https://raw.githubusercontent.com/Project-Backstab/BF2MC-Emulator-Installer/main/icons/folder_icon.png"
$buttonInstallDirSelect.SizeMode  = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$buttonInstall                   = New-Object system.Windows.Forms.Button
$buttonInstall.text              = "Install"
$buttonInstall.width             = 162
$buttonInstall.height            = 44
$buttonInstall.visible           = $true
$buttonInstall.enabled           = $true
$buttonInstall.location          = New-Object System.Drawing.Point(547,402)
$buttonInstall.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$MainWindow.controls.AddRange(@($textboxInstallDir,$buttonInstallDirSelect,$buttonInstall))

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
    Pause
    Write-Host "Downloading dependencies..."
    # Invoke-WebRequest -Uri $zip7Url -OutFile $zip7FilePath
    
    # Download the PCSX2 .7z file
    $pcsx2FilePath = Join-Path $textboxInstallDir.text $pcsx2PackageName
    Clear-Host
    Write-Host "Downloading PCSX2 Emulator..."
    # Invoke-WebRequest -Uri $pcsx2Url -OutFile $pcsx2FilePath
    
    # Extract PCSX2
    Clear-Host
    Write-Host "Extracting PCSX2 Emulator..."
    $pcsx2InstallPath = Join-Path $textboxInstallDir.text "PCSX2-v1.7.3858"
    & $zip7FilePath x $pcsx2FilePath -o"$pcsx2InstallPath"
    Write-Host "Unpacking completed."
    
    # Clean up
    Clear-Host
    Write-Host "Cleaning up..."
    # Remove-Item -Path $zip7FilePath
    # Remove-Item -Path $pcsx2FilePath
    
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