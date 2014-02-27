my pc's dresses!

Thanks to Daniele Bellavista, that help me organize these things in the right
way!

## Directories
1. __Gdbinit__ : reverser's (http://reverse.put.as) gdbinit
2. __scripts__ : utility scripts
3. __shell__   : common configuration for shells (aliases, environment and functions).
4. __vim__     : vim configuration
5. __X__       : X windows manager and desktop environment configuration
6. __zsh__     : zsh stuffs

## How to install

The python script `install_configuration.py` provides a quick way to install
the configuration by means of symlinks.

The VIM plugins (in `vim/vim/bundle`) are all submodule! Remember to launch

```
git submodule update --init --recursive
```  
