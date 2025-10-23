###############################################################################
# ~/.zshrc
# Author: Rizauddin Saian
# Description:
#   Personal Zsh configuration file for macOS + Homebrew setup.
#   Uses Oh My Zsh with Powerlevel10k, custom PATHs for dev tools,
#   and plugins for syntax highlighting, autosuggestions, and zoxide.
#
# Repository:
#   https://github.com/rizauddin/dotfiles
#
# Management:
#   This file is managed using GNU Stow.
#   To deploy (symlink) it to your home directory:
#     cd ~/.dotfiles && stow -v zsh
#
# Notes:
#   - Safe for public sharing (no private tokens or credentials)
#   - Locale and SDK paths are macOS standard
#   - Machine-specific or private settings should go into ~/.zshrc.local
#   - If you do NOT use Weka or Myra, comment out the following two lines:
#       [ -f "/Applications/weka-3.8.6.app/Contents/app/weka.jar" ] && \
#         export CLASSPATH="${CLASSPATH}:/Applications/weka-3.8.6.app/Contents/app/weka.jar"
#       [ -f "/Applications/Research/myra-5.0.jar" ] && \
#         export CLASSPATH="${CLASSPATH}:/Applications/Research/myra-5.0.jar"
#     These are optional and used only for Java-based data mining tools.
###############################################################################

##### Locale #####
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export TERM=xterm-256color

##### Oh My Zsh #####
export ZSH="$HOME/.oh-my-zsh"
ZSH_DISABLE_COMPFIX=true
ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

##### Powerlevel10k #####
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

##### Homebrew #####
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
export PATH="/opt/homebrew/sbin:$PATH"

##### Java / OpenJDK #####
if /usr/libexec/java_home -v 21 >/dev/null 2>&1; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 21)
else
  export JAVA_HOME=$(/usr/libexec/java_home)
fi
export PATH="$JAVA_HOME/bin:$PATH"
[ -d "/opt/homebrew/opt/openjdk/include" ] && export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

##### Core Directories #####
export PATH="$HOME/bin:/opt/homebrew/bin:$PATH"

##### NVM #####
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

##### Flutter / Dart #####
if ! command -v flutter >/dev/null 2>&1; then
  for f in /opt/homebrew/Caskroom/flutter/*/flutter/bin; do
    [ -d "$f" ] && export PATH="$f:$PATH" && break
  done
fi

##### Android SDK / Ionic / Capacitor #####
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export ANDROID_AVD_HOME="$HOME/.android/avd"
export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator"
if [ -d "$ANDROID_SDK_ROOT/build-tools" ]; then
  latest_bt="$(ls -1d "$ANDROID_SDK_ROOT"/build-tools/* 2>/dev/null | sort -V | tail -1)"
  [ -n "$latest_bt" ] && export PATH="$PATH:$latest_bt"
fi

##### Python (Conda) #####
export PATH="/opt/homebrew/anaconda3/bin:$PATH"

##### R #####
export PATH="/Library/Frameworks/R.framework/Resources:$PATH"

##### CLASSPATH (Weka & Myra) #####
[ -f "/Applications/weka-3.8.6.app/Contents/app/weka.jar" ] && export CLASSPATH="${CLASSPATH}:/Applications/weka-3.8.6.app/Contents/app/weka.jar"
[ -f "/Applications/Research/myra-5.0.jar" ] && export CLASSPATH="${CLASSPATH}:/Applications/Research/myra-5.0.jar"

##### Aliases #####
alias ls='ls -G'
alias ll='ls -lG'
alias chrome='open -a "Google Chrome" -n'

##### Radio Stations #####
alias suriafm='mpv https://playerservices.streamtheworld.com/api/livestream-redirect/SURIA_FMAAC_SC'
alias sinarfm='mpv https://stream.rcs.revma.com/crec9cmbv4uvv/hls.m3u8'
alias hotfm='mpv https://stream.rcs.revma.com/drakdf8mtd3vv/hls.m3u8'
alias erafm='mpv https://stream.rcs.revma.com/crec9cmbv4uvv/hls.m3u8'
alias ikimfm='mpv https://ais-sa8.cdnstream1.com/5035/playlist.m3u8'
alias perlisfm='mpv https://playerservices.streamtheworld.com/api/livestream-redirect/PERLIS_FMAAC_SC'
alias manisfm='mpv https://stream.rcs.revma.com/nzgauqq1v7zuv'
alias kedahfm='mpv https://playerservices.streamtheworld.com/api/livestream-redirect/KEDAH_FMAAC_SC'
alias klfm='mpv https://playerservices.streamtheworld.com/api/livestream-redirect/KL_FMAAC_SC'
alias molekfm='mpv https://stream-eu-a.rcs.revma.com/z56xa78mtd3vv/20_1foge7aluqmzl02/playlist.m3u8'
alias zayanfm='mpv https://stream-eu-a.rcs.revma.com/7ww2a4tbv4uvv/64_2yvaj6nnb69x02/playlist.m3u8'

##### Git Prompt #####
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{blue}git:%f%F{red}(%b)%f'
setopt PROMPT_SUBST
#PROMPT='%F{yellow}[%F{magenta}%n%f@%F{cyan}%m%f%F{yellow}] %.${vcs_info_msg_0_}%f %% '
PROMPT='%F{yellow}[ZSH]%f %.${vcs_info_msg_0_}%f %% '

##### Plugins #####
[ -s "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && . "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[ -s "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && . "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

##### zoxide #####
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

##### History & key bindings #####
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history hist_expire_dups_first hist_ignore_dups hist_verify
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

##### SDKMAN #####
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
