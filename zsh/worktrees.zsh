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

wt_repo_root() {
  if [[ -d "$PWD/.git" ]]; then
    echo "$PWD"
    return 0
  fi

  echo "error: run this from the repo root (the directory containing .git)" >&2
  return 1
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
  local branch="$1" dir="$2"

  [[ -z "$branch" || -z "$dir" ]] && {
    echo "usage: wtadd <branch> <dir-name>"
    return 1
  }

  local root gitdir default
  root="$(wt_repo_root)" || return 1
  gitdir="$root/.git"
  default="$(wt_default_branch "$gitdir")" || return 1

  git --git-dir="$gitdir" fetch origin || return 1
  git --git-dir="$gitdir" worktree add -b "$branch" "$root/$dir" "origin/$default"
}

# add a worktree from an existing remote branch
wttrack() {
  local branch="$1" dir="$2"
  [[ -z "$branch" || -z "$dir" ]] && {
    echo "usage: wttrack <remote-branch> <dir-name>"
    return 1
  }

  local root gitdir
  root="$(wt_repo_root)" || return 1
  gitdir="$root/.git"

  git --git-dir="$gitdir" fetch origin "$branch" || return 1
  
  if git --git-dir="$gitdir" show-ref --verify --quiet "refs/heads/$branch"; then
    # branch already exists → just attach
    git --git-dir="$gitdir" worktree add "$root/$dir" "$branch"
  else
    # create branch from fetched commit
    git --git-dir="$gitdir" worktree add -b "$branch" "$root/$dir" FETCH_HEAD
  fi
}

# list worktrees for a repo
wtls() {
  local root gitdir
  root="$(wt_repo_root)" || return 1
  gitdir="$root/.git"

  git --git-dir="$gitdir" worktree list
}

# remove a worktree
wtrm() {
  local branch="$1"
  [[ -z "$branch" ]] && {
    echo "usage: wtrm <branch>"
    return 1
  }

  local root gitdir
  root="$(wt_repo_root)" || return 1
  gitdir="$root/.git"

  git --git-dir="$gitdir" worktree remove "$root/$branch"
}

# jump into a repo worktree
wtcd() {
  local branch="$1"
  local root gitdir

  root="$(wt_repo_root)" || return 1
  gitdir="$root/.git"

  if [[ -z "$branch" ]]; then
    branch="$(wt_default_branch "$gitdir")" || return 1
  fi

  cd "$root/$branch" || return 1
}

wtprune() {
  local root gitdir
  root="$(wt_repo_root)" || return 1
  gitdir="$root/.git"
  git --git-dir="$gitdir" worktree prune
}

wtbranches() {
  local repo="$1"
  [[ -z "$repo" ]] && {
    echo "usage: wtbranches <repo>"
    return 1
  }

  local root gitdir
  root="$(wt_repo_root)" || return 1
  gitdir="$root/.git"

  git --git-dir="$gitdir" branch
}
