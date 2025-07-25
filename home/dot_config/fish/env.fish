set -xg TERMINAL ghostty
set -xg EDITOR nvim

### GO LANG
set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin
# if test -d ~/go
#     set --export --universal GOROOT (go env GOROOT)
#     set --export --universal GOPATH (go env GOPATH)
#     set --export --universal GOBIN (go env GOBIN)
#     set --export --universal PATH $PATH $GOBIN $GOROOT/bin
#     alias cdgo="cd $GOPATH/src"
#     alias gomodOn="set -gx GO111MODULE on"
#     alias gomodOff="set -gx GO111MODULE off"
# end
