#!/bin/bash 

function list_erlangs() { 
  _get_erlangs
  local erlangs=($AvailableErls)
  local current=`ls -l $ERL_HOME | awk '/^l/' | sed 's/^l.*-> \(.*\)/\1/'`
  for i in "${erlangs[@]}"; do
    if [ $i = $current ]; then echo "$current *"; else echo $i; fi
  done
}

function change_erlang() {
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

function _get_erlangs() {
  AvailableErls=`ls -l $ERL_HOME | awk '/^d/' | rev | cut -d ' ' -f1 | rev | tr '\n' ' ' `
}

function _change_erlang() {
  _get_erlangs
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$AvailableErls" -- $cur) )
}

alias ce="change_erlang"
alias le="list_erlangs"

complete -F _change_erlang change_erlang
complete -F _change_erlang ce
