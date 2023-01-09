# Installation

## Windows
clone this repo into %USERPROFILE% directory (into `C:\Users\USERNAME\dotfiles\`)  
then create these symlinks from admin basic cmd prompt (not powershell):  
```
cd C:\Users\USERNAME
mklink /D  vimfiles\  dotfiles\vimfiles\
mklink /D  .vim\      dotfiles\vimfiles\
mklink     .minttyrc  dotfiles\.minttyrc
mklink     .gitconfig  dotfiles\.gitconfig
```
the `.vim` dir is necessary because git for windows mintty shell ships its own version of vim which looks in the unix locations  

then `Win+R` then `shell:startup` and add shortcuts to the AHK scripts to startup

## Linux
clone this repo into $HOME directory  
then create the symlinks with `ln -s source link`


# script the symlinks?

https://github.com/magicmonty/dotfiles-windows/blob/master/install.bat  
https://stackoverflow.com/questions/5034076/what-does-dp0-mean-and-how-does-it-work  
https://stackoverflow.com/questions/894430/creating-hard-and-soft-links-using-powershell/34905638#34905638  

