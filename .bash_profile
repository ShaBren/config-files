export PS1="\n\n\n\u@\h | \@ \d | \w\n>>> "
export PATH=~/bin:/usr/local/bin:/usr/local/mysql/bin:$PATH:/usr/local/sbin
export EDITOR=vim
export VISUAL=vim

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
alias tpol="ssh -XY root@tpol.xvt.com"
alias drop1="ssh root@drop1.shabren.com"
alias technic="/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home/bin/java -jar ~/Downloads/TechnicLauncher.jar"
alias love="/Applications/love.app/Contents/MacOS/love"
#alias vim="nvim"
alias haste="HASTE_SERVER='http://drop1.shabren.com:7777' haste | pbcopy"
alias muzak="ncmpcpp"
alias parsedata="python3 ~/Development/intertalk-data-parser/parse.py"
alias mounttpol="sshfs root@tpol.xvt.com:/var/www/pantel/installers ~/tpol-remote/"
#git filter-branch --prune-empty -d /tmp/gitscratch --index-filter "git rm --cached -f --ignore-unmatch oops.iso" --tag-name-filter cat -- --all

alias tta='echo "In  :" `date +"%H:%M:%S"` >> ~/Dropbox/timelogs/`date +"%Y-%m-%d"`'
alias ttd='echo "Out :" `date +"%H:%M:%S"` >> ~/Dropbox/timelogs/`date +"%Y-%m-%d"`'

alias tunnel1='ssh -N -L 5901:localhost:5901 root@tpol.xvt.com'

export PYTHONSTARTUP=~/.pyrc.py
#export PYTHONPATH=$(brew --prefix)/lib/python2.7/site-packages:$PYTHONPATH

source ~/config-files/.shell_prompt.sh
source ~/config-files/git-completion.sh
