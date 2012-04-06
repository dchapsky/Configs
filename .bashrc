# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


if [[ $- != *i* ]] ; then
		# Shell is non-interactive.  Be done now!
			return
		fi

		##### exports ####
		export LANG=en_US.UTF-8
		#### end exports ####

		#### aliases ####
		alias ll='ls -alF'
		alias la='ls -A'
		alias l='ls -CF'
		alias x='exit'
		alias same="find . -type f -print0 | xargs -0 -n1 md5sum | sort -k 1,32 | uniq -w 32 -d --all-repeated=separate | sed -e 's/^[0-9a-f]*\ *//;'"
		alias dud='du --max-depth=1 -h'
		alias dud100='du -a --max-depth=1 / | sort -n | awk '\''{if($1 > 102400) print $1/1024 "MB" " " $2 }'\'''
		alias p='pushd'
		alias o='popd'
		alias lsd='ls -F | grep /'
		alias push='git push -u origin master'
		#### end aliases ####

		#### tmux shell init ####
		tmux_count=`tmux ls | wc -l`
		if [[ "$tmux_count" == "0" ]]; then
			    tmux -2
		    else
			        if [[ -z "$TMUX" ]]; then
					        if [[ "$tmux_count" == "1" ]]; then
							            session_id=1
								            else
										                session_id=`echo $tmux_count`
												        fi
													    tmux -2 new-session -d -s $session_id
													        tmux -2 attach-session -t $session_id
														    fi
													    fi
													    #### tmux init end ####

													    #### prompt stuff ####
													    function prompt_command {
													    let prompt_line=${LINES}
													    newPWD="${PWD}"
												    }

												    PROMPT_COMMAND=prompt_command

												    function load_out() {
												      echo -n "$(uptime | sed -e "s/.*load average: \(.*\...\), \(.*\...\), \(.*\...\).*/\1/" -e "s/ //g")"
											      }

											      function load_color() {
											        gray=0
												  red=1
												    green=2
												      yellow=3
												        blue=4
													  magenta=5
													    cyan=6
													      white=7

													        # Colour progression is important ...
														  #   bold gray -> bold green -> bold yellow -> bold red ->-
														    #   black on red -> bold white on red
														      #
														        # Then we have to choose the values at which the colours switch, with
															  # anything past yellow being pretty important.

															    tmp=$(echo $(load_out)*100 | bc)
															      let load100=${tmp%.*}
															        if [ ${load100} -lt 70 ]
																	  then
																		      tput bold ; tput setaf ${gray}
																		        elif [ ${load100} -ge 70 ] && [ ${load100} -lt 120 ]
																				  then
																					      tput bold ; tput setaf ${green}
																					        elif [ ${load100} -ge 120 ] && [ ${load100} -lt 200 ]
																							  then
																								      tput bold ; tput setaf ${yellow}
																								        elif [ ${load100} -ge 200 ] && [ ${load100} -lt 300 ]
																										  then
																											      tput bold ; tput setaf ${red}
																											        elif [ ${load100} -ge 300 ] && [ ${load100} -lt 500 ]
																													  then
																														      #tput setaf ${gray} ; tput setab ${red}
																														          tput setaf ${blue} ; tput setab ${red}
																															    else
																																        tput bold ; tput setaf ${white} ; tput setab ${red}
																																	  fi
																																  }

																																  #PS1="\[\033[\${prompt_line};0H\]\[\e[30;1m\](\[\$(load_color)\]\$(load_out)\[\e[0m\]\[\e[30;1m\])-(\[\[\e[32;1m\]\w\[\e[30;1m\])-(\[\e[32;1m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\e[30;1m\])-> \[\e[0m\]"
																																  PS1="\[\033[\${prompt_line};0H\]\[\e[30;1m\]-(\[\[\e[32;1m\]\w\[\e[30;1m\])-(\[\[\e[32;1m\]\h\[\e[30;1m\])-(\[\e[32;1m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\e[30;1m\])-> \[\e[0m\]"
																																  #### end prompt stuff ####
