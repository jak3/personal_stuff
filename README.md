my pc's dresses!

Thanks to Daniele Bellavista, that help me organize these things in the right
way!

## Directories
1. __Gdbinit__: reverser's (http://reverse.put.as) gdbinit
2. __config__: various configuration and templates, such as MoC and cmake.
3. __scripts__: utility scripts
4. __shell__: common configuration for shells (aliases, environment and functions).
5. __vim__: vim configuration
6. __X__: X windows manager and desktop environment configuration

## How to install

The python script `install_configuration.py` provides a quick way to install
the configuration by means of symlinks.

The VIM plugins (in `vim/vim/bundle`) are all submodule! Remember to launch

```
git submodule init && git submodule update --init --recursive && git submodule foreach git pull origin master
```  
