#!/bin/sh
if command -v hub >/dev/null 2>&1; then
	alias git='hub'
fi

alias gl='git pull --prune'
alias glg="git log --graph --decorate --oneline --abbrev-commit"
alias glga="glg --all"
alias gp='git push origin HEAD'
alias gpa='git push origin --all'
alias gd='git diff'
alias gc='git commit -s'
alias gca='git commit -s -a'
alias gco='git checkout'
alias gb='git branch -v'
alias ga='git add'
alias gaa='git add -A'
alias gcm='git commit -s -m'
alias gcam='git commit -s -a -m'
alias gs='git status -sb'
alias gpr='gp && git pr'
alias glnext='git log --oneline $(git describe --tags --abbrev=0 @^)..@'

if command -v svu >/dev/null 2>&1; then
	alias gtpatch='echo `svu p`; git tag `svu p`'
	alias gtminor='echo `svu m`; git tag `svu m`'
fi

gi() {
	curl -s "https://www.gitignore.io/api/$*"
}

# List git branches on the local machine sorted by recent updates, adding a star to remote tracking branches
# function git_list_branches() {
#   RED="\e[91m";
#   for branch in $(git branch | sed s/^..//); do
#     time_ago=$(git log -1 --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $branch --);
#     # Add a red star to mark branches that are tracking something upstream
#     tracks_upstream=$(if [ "$(git rev-parse $branch@{upstream} 2>/dev/null)" ]; then printf "$RED★"; fi);
#     printf "%-53s - %s %s\n" $time_ago $branch $tracks_upstream;
#   done | sort;
# }

# # The rest of my fun git aliases
# alias gl='git pull --prune'
# alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
# alias gp='git push origin HEAD'

# # Remove `+` and `-` from start of diff lines; just rely upon color.
# alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'

# alias gc='git commit'
# alias gca='git commit -a'
# alias gco='git checkout'
# alias gcb='git copy-branch-name'
# alias gb='git branch'
# alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
# alias gac='git add -A && git commit -m'

# alias gss="git status -s"
# alias gp="git push origin HEAD"
# alias gpt="git push origin HEAD && git push --tags"
# alias wip="git commit -m'WIP' . && git push origin HEAD"
# alias grok="ngrok start rem.jsbin-dev.com static.rem.jsbin-dev.com learn.rem.jsbin-dev.com"
# alias gl='git log'
# alias glp5='git log -5 --pretty --oneline' # view your last 5 latest commits each on their own line
# alias glt='git log --all --graph --decorate --oneline --simplify-by-decoration' # pretty branch status
# alias glsw='git log -S' # search the commit history for the word puppy and display matching commits (glsw [word])
# alias gs='git status'
# alias gd='git diff'
# alias gm='git commit -m'
# alias gam='git commit -am'
# alias gb='git branch'
# alias gc='git checkout'
# alias gra='git remote add'
# alias grr='git remote rm'
# alias gbt=git_list_branches
# alias gpu='git pull origin HEAD --prune'
# alias gcl='git clone'
# alias gta='git tag -a -m'
# alias gf='git reflog' # allows you to see every step you have made with git allowing you to retract and reinstate your steps
# alias gap='git add -p' # step through each change, or hunk
# alias gsl='git shortlog -sn' # quickly get a list of contributors and see how many commits each person has
# alias gws='git diff --shortstat "@{0 day ago}"' # how many lines of code you have written today
# alias gwts='git ls-files | xargs wc -l' # count number of lines of code in a git project
# alias ggmp='git checkout -' # jump back to to your last branch
# alias gst='git stash' # stash git changes and put them into your list
# alias gdtp='git stash pop' # bring back your changes, but it removes them from your stash
# alias gchp='git cherry-pick' # cherry pick the committed code in your own branch (gchp [hash])
# alias gcln='git clean -xfd' # remove untracked files

# # Undo a `git push`
# alias undopush="git push -f origin HEAD^:master"

# # Gist
# if (( $+commands[gist] ))
# then
#   alias gist-paste="gist --private --copy --paste --filename"  # gist-paste filename.ext -- create private Gist from the clipboard contents
#   alias gist-file="gist --private --copy"  # gist-file filename.ext -- create private Gist from a file
# fi
