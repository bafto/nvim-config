# Neovim Config

## On Linux

```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install neovim
sudo apt-get install ripgrep
sudo apt-get install fd-find

git clone git@github.com:bafto/nvim-config.git ~/.config/nvim
```

## On Windows

Install chocolatey:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Setup:
```powershell
choco upgrade chocolatey -y
choco install neovim -y
choco install ripgrep -y
choco install fd -y

git clone https://github.com/bafto/nvim-config.git C:/Users/<username>/AppData/Local/nvim
```

Optionally install [Windows Terminal](https://apps.microsoft.com/detail/9n0dx20hk701?hl=de-de&gl=de) and configure it to use PowerShell (*Not* Windows Powershell):
```powershell
choco install powershell-core -y
```

## On all Systems

Configure your terminal to use the provided [font](https://github.com/bafto/nvim-config/tree/master/font).
