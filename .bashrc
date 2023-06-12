###########################################################################
#
#
#                   ██████╗  █████╗ ███████╗██╗  ██╗
#                   ██╔══██╗██╔══██╗██╔════╝██║  ██║
#                   ██████╔╝███████║███████╗███████║
#                   ██╔══██╗██╔══██║╚════██║██╔══██║
#                   ██████╔╝██║  ██║███████║██║  ██║
#                   ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
#
#                  https://github.com/kalexnolasco
#                  https://github.com/kalexnolasco/bashrc/
#
###########################################################################
# Colores para la terminal
COLOR_LIGHT_RED='\033[0;91m'
COLOR_RED='\033[0;31m'
COLOR_LIGHT_GREEN='\033[0;92m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_BLUE='\033[0;94m'
COLOR_BLUE='\033[0;34m'
COLOR_LIGHT_YELLOW='\033[0;93m'
COLOR_YELLOW='\033[0;33m'
COLOR_MAGENTA='\033[0;35m'
COLOR_CYAN='\033[0;36m'
COLOR_WHITE='\033[0;37m'
COLOR_GRAY='\033[0;90m'
COLOR_END='\033[0m'

# If not running interactively, don't do anything(Si no se está ejecutando de forma interactiva, no haga nada)
# shell iterativo: el shell muestra un indicador de shell y espera a que el usuario escriba un comando.
# shell no interactivo: el shell no muestra un indicador de shell y ejecuta un script.
case $- in
 *i*) ;;
   *) return ;;
esac

# HISTCONTROL: lista de valores separados por dos puntos que controlan cómo se guardan los comandos en la lista del historial.
# Nos permite almacenar el historial de bash de manera más eficiente.
# Se puede usar para ignorar los comandos duplicados o los comandos con espacios en blanco iniciales o ambos.
## ignoredups: ignora los comandos duplicados -----------------------------------------------------------> HISTCONTROL=ignoredups
## ignorespace: ignora los comandos que comienzan con un espacio en blanco ------------------------------> HISTCONTROL=ignorespace
## ignoreboth: ignora los comandos duplicados y los comandos que comienzan con un espacio en blanco -----> HISTCONTROL=ignoreboth (recomendado) o HISTCONTROL=ignorespace:ignoredups
HISTCONTROL=ignorespace:ignoredups
# HISTSIZE: Es la cantidad de líneas o comandos que se almacenan en la memoria en una lista de historial mientras su sesión de bash está en curso.
# HISTFILESIZE: Es el número de líneas o comandos que:
#               (a) están permitidos en el archivo de historial en el momento de inicio de una sesión, y
#               (b) se almacenan en el archivo de historial al final de su sesión bash para usar en sesiones futuras.
HISTSIZE=1000
HISTFILESIZE=3000
# HISTTIMEFORMAT: Especifica cómo se almacenarán las marcas de tiempo en el archivo de historial.
#                 Si se establece en un formato vacío, no se almacenarán marcas de tiempo.
#                 Si no se establece, se almacenarán marcas de tiempo en el formato predeterminado.
#                 Si se establece en un formato que no contiene caracteres de formato de fecha y hora, se almacenarán marcas de tiempo en ese formato.
#                 Si se establece en un formato que contiene caracteres de formato de fecha y hora, se almacenarán marcas de tiempo en ese formato y se utilizará ese formato para mostrar marcas de tiempo.
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S -> "
# HISTIGNORE: Es una lista de patrones de comandos que se deben excluir del historial.
#             Si un patrón de comando coincide con uno de los patrones de HISTIGNORE, el comando no se almacena en el historial.
HISTIGNORE='ls *:cd *:pwd:exit:date *:* --help'
# HISTFILE: Especifica el nombre del archivo de historial.
#           Si no se establece, el archivo de historial predeterminado es ~/.bash_history.
HISTFILE=~/.bash_history

# shopt: Se utiliza para cambiar la configuración opcional de bash -> Documentación: https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
# histappend: Si se establece, el historial de bash se anexará al archivo de historial existente (en lugar de sobrescribirlo).
shopt -s histappend
# checkwinsize: Si se establece, bash comprobará el tamaño de la ventana después de cada comando y, si es necesario, actualizará los valores de LINES y COLUMNS.
shopt -s checkwinsize


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


#############################################
####FUNCUINES DE AYUDA PARA LA TERMINAL######
function find_largest_files() {
  # only files in current directory ignore hidden directories
  # sorted by size
  # human-readable
  # 20 largest
  find "${PWD}" -type f -not -path '*/.*' -exec du -Sh {} + | sort -rh | head -n 20
}

function find_largest_directories() {
  # only directories in current directory ignore hidden directories
  # sorted by size
  # human-readable
  # 20 largest
  find "${PWD}" -type d -not -path '*/.*' -exec du -Sh {} + | sort -rh | head -n 20
}
####FUNCUINES DE AYUDA PARA LA TERMINAL######
#############################################

#############################################
####FUNCUINES DE AYUDA PARA GIT##############

# Lista de paquetes necesarios para el funcionamiento de las funciones de ayuda para git
PACKAGES=(git fzf)
MISSING_PACKAGES=()
for p in "${PACKAGES[@]}"; do
  if ! dpkg -s "$p" >/dev/null 2>&1;
   then
    MISSING_PACKAGES+=("$p")
  fi
done
if [ ${#MISSING_PACKAGES[@]} -gt 0 ];
then
  packages=$(printf " %s" "${MISSING_PACKAGES[@]}")
  echo -e "#############################################"
  echo -e "Please install ${COLOR_LIGHT_BLUE}$packages${COLOR_END} package -> ${COLOR_LIGHT_YELLOW}sudo apt install $packages${COLOR_END}"
  echo -e "#############################################"
  echo -e ""
fi


function __git_status() {
  # git status complete
  git status --untracked-files=all -v --show-stash --ahead-behind --find-renames --branch
}

function __git_current_branch() {
  # show current branch
  git rev-parse --abbrev-ref HEAD
}

function __git_all_branches() {
  # show all branches
  git branch -a | grep -v HEAD | cut -d'*' -f2- | sed -e 's/^[[:space:]]*//' | sed -e 's/[[:space:]]*$//'
}

function git_log() {
  # git log with pretty format
  git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all
}

function git_branch() {
  # show current branch with information
  git branch -vva
}

function git_tags() {
  # show all tags
  git tag -l
}

function git_checkout_branch() {
  # Check if git status is clean
  if [[ -z $(git status --porcelain) ]];
  then
    local current_branch=$(__git_current_branch)
    local new_branch=$(__git_all_branches | fzf --multi --height=90% --margin=5%,2%,2%,5% --reverse --black)
    # remove remote/origin
    new_branch=$(echo "$new_branch" | sed -e 's/^remotes\/origin\///')
    # if current_branch is empty or equal to new_branch return
    if [[ -z "$new_branch" ]] || [[ "$current_branch" == "$new_branch" ]];
    then
      return
    fi
    # check if branch exists in local
    if [[ -z $(git branch --list "$new_branch") ]];
    then
      # check if branch exists in remote
      if [[ -z $(git ls-remote --heads origin "$new_branch") ]];
      then
        echo -e "${COLOR_YELLOW}Branch${COLOR_END}:[${COLOR_RED}$new_branch${COLOR_END}]${COLOR_YELLOW} does not exist in remote${COLOR_END}"
        return
      else
        # create new branch from remote
        git checkout -b "$new_branch" "origin/$new_branch"
      fi
    else
      # checkout branch from local
      git checkout "$new_branch"
    fi
  else
    echo -e "${COLOR_RED}Git status is not clean${COLOR_END}"
    __git_status
  fi
}

function git_checkout_tag() {
  # Checkout if git status is clean
  if [[ -z $(git status --porcelain) ]]; then
    local current_branch=$(__git_current_branch)
    local new_tag
    new_tag=$(git_tags | fzf --multi --height=90% --margin=5%,2%,2%,5% --reverse --black)
    # if current_branch is empty or equal to new_tag return
    if [[ -z "$new_tag" ]] || [[ "$current_branch" == "$new_tag" ]];
    then
      return
    fi
    # check if branch exists in local
    if [[ -z $(git tag -l "$new_tag") ]]; then
      # check if branch exists in remote
      if [[ -z $(git ls-remote --tags origin "$new_tag") ]]; then
        echo -e "${COLOR_YELLOW}Tag${COLOR_END}:[${COLOR_RED}$new_tag${COLOR_END}]${COLOR_YELLOW} does not exist in remote${COLOR_END}"
        return
      else
        # git checkout specific tag
        git checkout tags/"$new_tag"
      fi
    else
      # checkout branch from local
      git checkout "$new_tag"
    fi
  else
    echo "Git status is not clean. Please commit or stash your changes."
  fi
}

function git_pull() {
  git config --global advice.statusHints false
  if [[ -z $(git status --porcelain) ]]; then
    local current_branch=$(__git_current_branch)
    echo -e "Current ${COLOR_YELLOW}Branch${COLOR_END}:[${COLOR_BLUE}${current_branch}${COLOR_END}]\n"
    local local_branch
    for local_branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
      # check if branch exists on remote
      if [[ -z $(git ls-remote --heads origin "$local_branch") ]]; then
        echo -e "${COLOR_YELLOW}Branch${COLOR_END}:[${COLOR_BLUE}${local_branch}${COLOR_END}] ${COLOR_RED}[Branch does not exist on remote]${COLOR_END}\n"
        continue
      fi
      git checkout "${local_branch}" >/dev/null 2>&1
      echo -e "${COLOR_YELLOW}Branch${COLOR_END}:[${COLOR_BLUE}${local_branch}${COLOR_END}] [${COLOR_GREEN}Pulling...${COLOR_END}]"
      git pull --summary --ff-only
      local exit_code=$?
      if [[ ${exit_code} -ne 0 ]]; then
        echo -e "${COLOR_YELLOW}Branch${COLOR_END}:[${COLOR_BLUE}${local_branch}${COLOR_END}] [${COLOR_RED}Failed to pull${COLOR_END}]\n"
      else
        echo -e "${COLOR_YELLOW}Branch${COLOR_END}:[${COLOR_BLUE}${local_branch}${COLOR_END}] [${COLOR_GREEN}Successfully pulled${COLOR_END}]\n"
      fi
    done
    git checkout "$current_branch" >/dev/null 2>&1
    echo -e "Checkout to ${COLOR_YELLOW}Branch${COLOR_END}:[${COLOR_BLUE}${current_branch}${COLOR_END}]"

  else
    echo "Git status is not clean. Please commit or stash your changes."
  fi
}

function git_stash() {
  # git stash with message
  local current_branch=$(__git_current_branch)
  local stash_name="$current_branch($(date +'%Y-%m-%d-%H:%M:%S'))"
  git stash save "$stash_name"
}

function git_stash_pop() {
  # git stash pop with fzf
  git stash list | fzf --multi --height=90% --margin=5%,2%,2%,5% --reverse --black | cut -d ':' -f1 | xargs git stash pop
}

# INI COLORS
PS1_COLOR_BLACK='\[\e[30m\]'
PS1_COLOR_RED='\[\e[31m\]'
PS1_COLOR_GREEN='\[\e[32m\]'
PS1_COLOR_YELLOW='\[\e[33m\]'
PS1_COLOR_BLUE='\[\e[38;5;21m\]'
PS1_COLOR_MAGENTA='\[\e[35m\]'
PS1_COLOR_CYAN='\[\e[36m\]'
PS1_COLOR_WHITE='\[\e[97m\]'
PS1_COLOR_END='\[\e[0m\]'
# check if git is installed
if [ -x "$(command -v git)" ]; then
  # git aliases
  source /etc/bash_completion.d/git-prompt
  export GIT_PS1_SHOWDIRTYSTATE='y'
  export GIT_PS1_SHOWSTASHSTATE='y'
  export GIT_PS1_SHOWUNTRACKEDFILES='y'
  export GIT_PS1_DESCRIBE_STYLE='contains'
  export GIT_PS1_SHOWUPSTREAM='verbose'

  # PS1 with git branch
  PS1="${PS1_COLOR_GREEN}\u${PS1_COLOR_END}@${PS1_COLOR_GREEN}\h${PS1_COLOR_END}:${PS1_COLOR_WHITE}\w${PS1_COLOR_END}${PS1_COLOR_GREEN}\$(__git_ps1 \"(%s)\")${PS1_COLOR_END}\$ "
else
  # PS1 without git branch
  PS1="${PS1_COLOR_GREEN}\u${PS1_COLOR_END}@${PS1_COLOR_GREEN}\h${PS1_COLOR_END}:${PS1_COLOR_WHITE}\w${PS1_COLOR_END}\$ "
fi

# INI ALIAS
## LS
alias ls='ls --color'
LS_COLORS='di=1;34:fi=0;97:ln=1;34;101:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=0;32:*.yml=0;91:*.ini=0;33:*.py=0;93'
export LS_COLORS
## GREP-EGREP-FGREP
alias grep='grep --color=always'
alias egrep='egrep --color=always'
alias fgrep='fgrep --color=always'
# load extra aliases if exists
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi
# END ALIAS

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


