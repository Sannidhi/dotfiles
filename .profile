export MAVEN_OPTS="-XX:+CMSClassUnloadingEnabled -XX:PermSize=256m -XX:MaxPermSize=1024m -Xmx2048m -Xms2048m"
export JAVA_HOME=$(/usr/libexec/java_home)


# Colours
       RED="\[\033[0;31m\]"
    YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
      BLUE="\[\033[0;34m\]"
 LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
     WHITE="\[\033[1;37m\]"
LIGHT_GRAY="\[\033[0;37m\]"
COLOR_NONE="\[\e[0m\]"
      GRAY="\[\033[1;30m\]"

# Get the current git branch, if there is one
function parse_git_branch {
 git rev-parse --git-dir &> /dev/null
 git_status="$(git status 2> /dev/null)"
 branch_pattern="^# On branch ([^${IFS}]*)"
 remote_pattern="# Your branch is (.*) of"
 diverge_pattern="# Your branch and (.*) have diverged"
 #if [[ ! ${git_status}} =~ "working directory clean" ]]; then
 #  state="${RED}⚡"
 #fi
 # add an else if or two here if you want to get more specific
 if [[ ${git_status} =~ ${remote_pattern} ]]; then
   if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
     remote="${YELLOW}↑"
   else
     remote="${YELLOW}↓"
   fi
 fi
 if [[ ${git_status} =~ ${diverge_pattern} ]]; then
   remote="${YELLOW}↕"
 fi
 if [[ ${git_status} =~ ${branch_pattern} ]]; then
   branch=${BASH_REMATCH[1]}
   echo " (${branch})${remote}${state}"
 fi
}

function prompt_func() {
 previous_return_value=$?;
 prompt="${TITLEBAR}${LIGHT_GRAY}\W${YELLOW}$(parse_git_branch)${COLOR_NONE}"
 if test $previous_return_value -eq 0
 then
   PS1="${GREEN}➜ {\h} ${COLOR_NONE}${prompt}${GREEN} \$${COLOR_NONE} "
 else
   PS1="${RED}➜ {\h} ${COLOR_NONE}${prompt}${RED} \$${COLOR_NONE} "
 fi
}

PROMPT_COMMAND=prompt_func

function gitrm() {
  git st | grep 'deleted' | awk '{print $3}' | xargs git rm
}

function gitlog() {
  git log --graph --decorate --pretty=oneline --abbrev-commit --all 
}

function gitdata() {
	git log --date=short --format="format:%h:%aN:%aE:%cd:%ct" --shortstat perl-5.10.0 |
	          awk 'BEGIN {print "Commit SHA1 Hash:" \
	                  "Author Name:" "Author e-mail:" "Date:" "Timestamp:" \
	                  "Files touched:" "Lines added:" "Lines deleted"}
	                  /^ / {n=0; print ":"$1":"$4":"$6; next}
	                  /^[^ ]/ {if (n) {print ":0:0:0"}; n=1; printf $0}' >history.csv	
}
alias mysqlstart='sudo /usr/local/mysql/support-files/mysql.server start'
alias mysqlstop='sudo /usr/local/mysql/support-files/mysql.server stop'
export PATH=$PATH:/usr/local/mysql/bin
export PATH=$PATH:/usr/local/git/bin/git
export PATH=$PATH:/Users/Thoughtworker/Downloads/apache-tomcat-6.0.36
export TOMCAT_HOME="/Users/Thoughtworker/Downloads/apache-tomcat-6.0.36"
