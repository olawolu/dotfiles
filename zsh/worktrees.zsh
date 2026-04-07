# base dir
wt_root() {
  echo "$PWD"
}

wt_default_branch() {
  local gitdir="$1" ref

  ref="$(git --git-dir="$gitdir" symbolic-ref --short HEAD 2>/dev/null)" || {
    echo "error: cannot determine default branch" >&2
    return 1
  }

  echo "$ref"
}

# create a new bare-controlled repo + main worktree
wtinit() {
  local name="$1" url="$2"

  [[ -z "$name" || -z "$url" ]] && {
    echo "usage: wtinit <name> <repo-url>"
    return 1
  }

  git rev-parse --is-inside-work-tree >/dev/null 2>&1 && {
    echo "error: run wtinit outside a git repo"
    return 1
  }

  local base root gitdir
  base="$(wt_root)" || return 1
  root="$base/$name"
  gitdir="$root/.git"

  mkdir -p "$root" || return 1
  git clone --bare "$url" "$gitdir" || return 1

  local default
  default="$(wt_default_branch "$gitdir")" || return 1

  git --git-dir="$gitdir" worktree add "$root/$default" "$default" || return 1
}

# add a new worktree from origin/main
wtadd() {
  local repo="$1"
  local branch="$2"

  [[ -z "$repo" || -z "$branch" ]] && {
    echo "usage: wtadd <repo> <branch>"
    return 1
  }

  local root gitdir default
  root="$(wt_root)/$repo"
  gitdir="$root/.git"
  default="$(wt_default_branch "$gitdir")" || return 1

  git --git-dir="$gitdir" fetch origin || return 1
  git --git-dir="$gitdir" worktree add -b "$branch" "$root/$branch" "origin/$default"
}

# add a worktree from an existing remote branch
wttrack() {
  local repo="$1"
  local branch="$2"

  [[ -z "$repo" || -z "$branch" ]] && {
    echo "usage: wttrack <repo> <remote-branch>"
    return 1
  }

  local root gitdir
  root="$(wt_root)/$repo"
  gitdir="$root/.git"

  git --git-dir="$gitdir" fetch origin || return 1
  git --git-dir="$gitdir" worktree add -b "$branch" "$root/$branch" "origin/$branch"
}

# list worktrees for a repo
wtls() {
  local repo="$1"
  [[ -z "$repo" ]] && {
    echo "usage: wtls <repo>"
    return 1
  }

  git --git-dir="$(wt_root)/$repo/.git" worktree list
}

# remove a worktree
wtrm() {
  local repo="$1"
  local branch="$2"

  [[ -z "$repo" || -z "$branch" ]] && {
    echo "usage: wtrm <repo> <branch>"
    return 1
  }

  git --git-dir="$(wt_root)/$repo/.git" worktree remove "$(wt_root)/$repo/$branch"
}

# jump into a repo worktree
wtcd() {
  local repo="$1" branch="$2"
  [[ -z "$repo" ]] && {
    echo "usage: wtcd <repo> [branch]"
    return 1
  }

  local root gitdir
  root="$(wt_root)/$repo"
  gitdir="$root/.git"

  if [[ -z "$branch" ]]; then
    branch="$(wt_default_branch "$gitdir")" || return 1
  fi
  cd "$(wt_root)/$branch" || return 1
}

wtprune() {
  local repo="$1"
  [[ -z "$repo" ]] && {
    echo "usage: wtprune <repo>"
    return 1
  }
  git --git-dir="$(wt_root)/$repo/.git" worktree prune
}

wtbranches() {
  local repo="$1"
  [[ -z "$repo" ]] && {
    echo "usage: wtbranches <repo>"
    return 1
  }
  git --git-dir="$(wt_root)/$repo/.git" branch
}
