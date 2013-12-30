# Reset
Color_Off="\[\033[0m\]"       # Text Reset

# Regular Colors
Black="\[\033[0;30m\]"        # Black
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
Purple="\[\033[0;35m\]"       # Purple
Cyan="\[\033[0;36m\]"         # Cyan
White="\[\033[0;37m\]"        # White

# Bold
BBlack="\[\033[1;30m\]"       # Black
BRed="\[\033[1;31m\]"         # Red
BGreen="\[\033[1;32m\]"       # Green
BYellow="\[\033[1;33m\]"      # Yellow
BBlue="\[\033[1;34m\]"        # Blue
BPurple="\[\033[1;35m\]"      # Purple
BCyan="\[\033[1;36m\]"        # Cyan
BWhite="\[\033[1;37m\]"       # White

# Underline
UBlack="\[\033[4;30m\]"       # Black
URed="\[\033[4;31m\]"         # Red
UGreen="\[\033[4;32m\]"       # Green
UYellow="\[\033[4;33m\]"      # Yellow
UBlue="\[\033[4;34m\]"        # Blue
UPurple="\[\033[4;35m\]"      # Purple
UCyan="\[\033[4;36m\]"        # Cyan
UWhite="\[\033[4;37m\]"       # White

# Background
On_Black="\[\033[40m\]"       # Black
On_Red="\[\033[41m\]"         # Red
On_Green="\[\033[42m\]"       # Green
On_Yellow="\[\033[43m\]"      # Yellow
On_Blue="\[\033[44m\]"        # Blue
On_Purple="\[\033[45m\]"      # Purple
On_Cyan="\[\033[46m\]"        # Cyan
On_White="\[\033[47m\]"       # White

# High Intensty
IBlack="\[\033[0;90m\]"       # Black
IRed="\[\033[0;91m\]"         # Red
IGreen="\[\033[0;92m\]"       # Green
IYellow="\[\033[0;93m\]"      # Yellow
IBlue="\[\033[0;94m\]"        # Blue
IPurple="\[\033[0;95m\]"      # Purple
ICyan="\[\033[0;96m\]"        # Cyan
IWhite="\[\033[0;97m\]"       # White

# Bold High Intensty
BIBlack="\[\033[1;90m\]"      # Black
BIRed="\[\033[1;91m\]"        # Red
BIGreen="\[\033[1;92m\]"      # Green
BIYellow="\[\033[1;93m\]"     # Yellow
BIBlue="\[\033[1;94m\]"       # Blue
BIPurple="\[\033[1;95m\]"     # Purple
BICyan="\[\033[1;96m\]"       # Cyan
BIWhite="\[\033[1;97m\]"      # White

# High Intensty backgrounds
On_IBlack="\[\033[0;100m\]"   # Black
On_IRed="\[\033[0;101m\]"     # Red
On_IGreen="\[\033[0;102m\]"   # Green
On_IYellow="\[\033[0;103m\]"  # Yellow
On_IBlue="\[\033[0;104m\]"    # Blue
On_IPurple="\[\033[10;95m\]"  # Purple
On_ICyan="\[\033[0;106m\]"    # Cyan
On_IWhite="\[\033[0;107m\]"   # White


Time12h="\T"
Time12a="\@"
Path="\w"
PathFull="\W"
NewLine="\n"
Jobs="\j"
Date="\d"
Host="\h"
User="\u"
 
source ~/.git-prompt.sh

function parse_git_dirty {
  echo -n $(git status 2>/dev/null | awk -v out=$1 -v std="dirty" '{ if ($0=="# Changes to be committed:") std = "uncommited"; last=$0 } END{ if(last!="" && last!="nothing to commit (working directory clean)") { if(out!="") print out; else print std } }')
}
function parse_git_branch {
  echo -n $(git branch --no-color 2>/dev/null | awk -v out=$1 '/^*/ { if(out=="") print $2; else print out}')
}
function parse_git_remote {
  echo -n $(git status 2>/dev/null | awk -v out=$1 '/# Your branch is / { if(out=="") print $5; else print out }')
}
#export PS1='$(pwd \l)\u@\h:\[33[33m\]\w\[33[0m\]$(parse_git_branch ":")\[33[36m\]$(parse_git_branch)\[33[0m\]$(parse_git_remote "(")\[33[35m\]$(parse_git_remote)\[33[0m\]$(parse_git_remote ")")\[33[0m\]$(parse_git_dirty  "[")\[33[31m\]$(parse_git_dirty )\[33[0m\]$(parse_git_dirty  "]")>'

export PS1="\n\n\n$Blue$User$IRed@$Cyan$Host $IRed|$Color_Off $Blue$Time12h $Date $IRed|$Color_Off $Green$Path $IRed|$Purple $(__git_ps1 "($Blue%s$Purple)")$Color_Off \n$Purple>>> $Color_Off"
#Prefix="\n\n\n$User@$Host | $Time12h $Date | "
#Suffix="$Path\n>>> "

#export PS1=$Prefix'$(git branch &>/dev/null;\
#if [ $? -eq 0 ]; then \
  #echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
  #if [ "$?" -eq "0" ]; then \
    ## @4 - Clean repository - nothing to commit
    #echo "'$Green'"$(__git_ps1 " (%s)"); \
  #else \
    ## @5 - Changes to working tree
    #echo "'$IRed'"$(__git_ps1 " {%s}"); \
  #fi) '$Suffix'"; \
#else \
  ## @2 - Prompt when not in GIT repo
  #echo "'$Suffix$Color_Off'"; \
#fi)'

