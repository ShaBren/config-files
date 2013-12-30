export PS1="\n\n\n\u@\h | \@ \d | \w\n>>> "
export PATH=~/bin:/usr/local/bin:/usr/local/mysql/bin:$PATH:/usr/local/sbin

alias irc="ssh -p1239 shabren@fltt.us"
alias lug="ssh -C shabren@short.csc.ncsu.edu"
alias navy="ssh root@10.18.0.8"
alias yeager="ssh root@10.18.0.2"
alias hpux3="ssh -X root@10.18.0.61"
alias ls="ls -GrAhlt" 
alias bell="ssh -X root@10.18.0.10"
alias glenn="ssh -X root@10.18.0.11"
alias runserv="python manage.py runserver"
alias mc="ssh -p1239 shabren@mc.shabren.com"
alias proxywork="ssh root@git.xvt.com -ND "
alias sbnet="ssh u40765419@stephenbryant.net"
alias ils1="ssh root@10.18.0.117"
alias ils2="ssh root@10.18.0.133"
alias cnils="ssh root@10.18.0.121"
alias mohils="ssh root@10.18.0.110"
alias tpol="ssh root@10.18.0.15"
alias drop1="ssh root@drop1.shabren.com"
alias technic="/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home/bin/java -jar ~/Downloads/TechnicLauncher.jar"
alias love="/Applications/love.app/Contents/MacOS/love"
alias vim="vim --servername floobits"
alias haste="HASTE_SERVER='http://drop1.shabren.com:7777' haste | pbcopy"
alias muzak="ncmpcpp"

export PYTHONSTARTUP=~/.pyrc.py
export PYTHONPATH=$(brew --prefix)/lib/python2.7/site-packages:$PYTHONPATH

source ~/config-files/.shell_prompt.sh
