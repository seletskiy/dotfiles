context-aliases:init

context-aliases:match is_inside_git_repo
    alias d='git diff'
    alias w='git diff --cached'
    alias a='git-smart-add'
    alias s='git status -s'
    alias o='git log --oneline --graph --decorate --all'
    alias c='git-smart-commit --amend'
    alias p='git-smart-push seletskiy'
    alias k='git checkout'
    alias j='k master'
    alias r='git-smart-remote'
    alias e='git rebase'
    alias b='git branch'
    alias h='git reset HEAD'
    alias i='git add -p'
    alias v='git mv'
    alias R='git rm'
    alias y='git show'
    alias ys='y --stat'
    alias q='git submodule update --init --recursive'

    alias r='u && p'
    alias G='cd-pkgbuild'
    alias S='git stash -u && git stash drop'
    alias R!='git rm -f'
    alias a!='git-smart-commit -a --amend'
    alias c!='git-smart-commit --amend'
    alias p!='git-smart-push seletskiy +`git symbolic-ref --short -q HEAD`'
    alias u='git-smart-pull --rebase'
    alias g='k pkgbuild'
    alias rs='git-smart-remote show'
    alias ru='git-smart-remote set-url'
    alias kb='git checkout -b'
    alias kB='git checkout -B'
    alias kb!='kB'
    alias rso='git-smart-remote show origin'
    alias st='git stash'
    alias fk='hub fork'
    alias pr='hub pull-request'
    alias lk='github-browse'

    function github-browse() {
        local file="$1"
        local line="${2:+#L$2}"

        local type=commit
        if [ "$file" ]; then
            type=blob
        fi

        hub browse -u -- $type/$(git rev-parse --short HEAD)/$file$line \
            2>/dev/null
    }

    alias mm='git-merge-with-rebase'
    function git-merge-with-rebase() {
        local branch=$(git rev-parse --abbrev-ref HEAD)
        if git rebase "${@}"; then
            git checkout $1
            git merge --no-ff "$branch" "${@}"
        fi
    }

    function _git-merge-with-rebase() {
        service="git-merge" _git "${@}"
    }

    compdef _git-merge-with-rebase git-merge-with-rebase

    alias me='git-remote-add-me'
    function git-remote-add-me() {
        if [ "$1" ]; then
            local repo="gh:seletskiy/$1"; shift
        else
            local repo=$(git remote show origin -n | awk '/Fetch URL/{print $3}')
            repo=$(sed -res'#(.*)/([^/]+)/([^/]+)$#\1/seletskiy/\3#' <<< $repo)
        fi

        git remote add seletskiy "$repo" "${@}"
    }

context-aliases:match "is_inside_git_repo && git remote show -n origin | grep -q git.rn"
    alias pr='stacket-pull-request-create && reviewers-add'

context-aliases:match "test -e PKGBUILD"

    alias g='go-makepkg-enhanced'
    alias m='makepkg -f'

    alias aur='push-to-aur'

    function push-to-aur() {
        local package_name="${1:-$(basename $(git rev-parse --show-toplevel))}"
        local package_name=${package_name%*-pkgbuild}
        local package_name=${package_name}-git

        git push ssh://aur@aur.archlinux.org/$package_name pkgbuild:master
    }

context-aliases:match "is_inside_git_repo && is_git_repo_dirty"
    alias c='git-smart-commit'

context-aliases:match "is_inside_git_repo && \
        [ \"\$(git log 2>/dev/null | wc -l)\" -eq 0 ]"

    alias c='git add . && git commit -m "initial commit"'

context-aliases:match "is_inside_git_repo && is_rebase_in_progress"
    alias m='git checkout --ours'
    alias t='git checkout --theirs'
    alias c='git rebase --continue'
    alias b='git rebase --abort'

context-aliases:match '[ "$(pwd)" = ~/.secrets ]'
    alias u='carcosa -Sn'

context-aliases:match 'is_inside_git_repo && [ -f .git/MERGE_MSG ]'
    alias m=':vim-merge'

    :vim-merge() {
        vim -o $(git status -s | grep "^UU " | awk '{print $2}')
    }
