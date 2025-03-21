# http://github.com/olivierverdier/zsh-git-prompt
# There is now a Haskell implementation as well (<3)
source /home/jake/repos/zsh-git-prompt/zshrc.sh
GIT_PROMPT_EXECUTABLE="haskell"

# A script to make using 256 colors in zsh less painful.
# P.C. Shyamshankar <sykora@lucentbeing.com>
# Source http://github.com/sykora/etc/blob/master/zsh/functions/spectrum/

typeset -Ag FX FG BG

FX=(
    reset     "%{[00m%}"
    bold      "%{[01m%}" no-bold      "%{[22m%}"
    italic    "%{[03m%}" no-italic    "%{[23m%}"
    underline "%{[04m%}" no-underline "%{[24m%}"
    blink     "%{[05m%}" no-blink     "%{[25m%}"
    reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

for color in {000..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done

# Show all 256 colors with color number
function spectrum_ls() {
  for code in {000..255}; do
    print -P -- "$FG[$code]$code: Test %{$reset_color%}"
  done
}

# Show all 256 colors where the background is set to specific color
function spectrum_bls() {
  for code in {000..255}; do
    ((cc = code + 1))
    print -P -- "$BG[$code]$code: Test %{$reset_color%}"
  done
}

PROMPT='
$(git_super_status)%f %{$reset_color%}%{$FG[220]%}%~ %{$reset_color%}%{$FG[124]%}
 %{$reset_color%}'
RPROMPT='%{$FG[172]%}[%{$reset_color%}%(?,%{$FG[220]%}%?%{$reset_color%},%{$FG[124]%}%?%{$reset_color%})%{$FG[172]%}] %{$reset_color%}%{$FG[226]%}%n%{$reset_color%}'

#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
