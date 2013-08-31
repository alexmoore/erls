#!/bin/bash 

function list_erlangs() { 
  _get_erlangs
  local erlangs=($AvailableErls)
  local current=`ls -l $ERL_HOME | awk '/^l/' | sed 's/^l.*-> \(.*\)/\1/'`
  for i in "${erlangs[@]}"; do
    if [ $i = $current ]; then echo "$current *"; else echo $i; fi
  done
}

function change_current_erlang() {
  local target=$1
  local cwd=$(pwd)
  
  if [ -z ${1+x} ]; 
  then 
    echo "USAGE: change_current_erlang TARGET_VERSION";
    echo "Use list_erlangs to review possible versions";
    return 1;
  fi

  if [ ! -d $ERL_HOME/$target ]; then
    echo "Target erlang $ERL_HOME/$target not found"'!';
    return 2;
  fi
  
  cd $ERL_HOME
  rm current
  ln -s $target current 
  cd $cwd

}

function _get_erlangs(){
  AvailableErls=`ls -l $ERL_HOME | awk '/^d/' | cut -d ' ' -f12- | tr '\n' ' ' `
}

_change_current_erlang() {
  _get_erlangs
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$AvailableErls" -- $cur) )
}

complete -F _change_current_erlang change_current_erlang

alias cce="change_current_erlang"
alias le="list_erlangs"

complete -F _change_current_erlang cce
