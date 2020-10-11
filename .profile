#!/bin/bash

export PATH=$HOME/.local/bin.local:$HOME/.local/bin:$HOME/.luarocks/bin:$PATH
export BROWSER=chromium
export TERMINAL=urxvt
export EDITOR=vim

if [ -e $HOME/.profile.local ]
then
	. $HOME/.profile.local
fi
