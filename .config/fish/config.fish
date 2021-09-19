function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)' # peco
  bind \cg 'ghq_repository_search'
end


## alias
### common
alias cat='bat'
alias top='ytop'
alias ls='lsd'
### gcp
alias gcp='gcloud_change_project'
alias ghome='gcloud config configurations activate home'
alias ghome2='gcloud config configurations activate home2'
alias gwork='gcloud config configurations activate work'

### kubectl
alias k='kubectl'
alias kg='kubectl get'
alias kga='kubectl get all'
alias kgaa='kubectl get all --all-namespaces'
alias kx='kubectl ctx'
alias kn='kubectl ns'
alias ka='kubectl argo rollouts'
alias kc='kubectl cert-manager'
alias st='stern'

### git
alias gis='git status'
alias gif='git diff'
alias g='git'
alias gc='gcloud'


### other
#### linux only
#alias pbcopy='xclip -selection c'
#alias pbpaste='xclip -selection c -o'


## ENV
set -Ux GOPATH $HOME/go
set -Ux PATH /usr/local/bin $PATH
set -Ux PATH $PATH $GOPATH/bin
set -Ux PATH /snap/bin $PATH
set -Ux fish_user_paths $HOME/.anyenv/bin $fish_user_paths

### Rust
set -Ux PATH $HOME/.cargo/bin $PATH

