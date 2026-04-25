# Git Commit Author Rule

This rule applies to all `awkwardsky` GitHub Pages project repositories,
including:

- `awkwardsky.github.io`
- `ReactionSpeedLab`
- `DashboardLab`

## Required Identity

All commits must use this Git identity for both author and committer:

```text
awkwardsky <9321793+awkwardsky@users.noreply.github.com>
```

Do not commit with these identities:

- `haru`
- `Haru`
- `aiueo`
- local machine emails such as `haru@Harus-Mac-mini.local`
- personal emails not attached to the `awkwardsky` GitHub account

## Configure A Repository

Run this inside each repository before committing:

```bash
git config user.name awkwardsky
git config user.email 9321793+awkwardsky@users.noreply.github.com
```

Verify the repository setting:

```bash
git config --get user.name
git config --get user.email
```

Expected output:

```text
awkwardsky
9321793+awkwardsky@users.noreply.github.com
```

## Check Commit History

Use this before pushing:

```bash
git log --format='%h%x09%an <%ae>%x09%cn <%ce>%x09%s' --max-count=20
```

Every line should show:

```text
awkwardsky <9321793+awkwardsky@users.noreply.github.com>
```

## Fix Existing History

Only rewrite history when the repository is owned by `awkwardsky` and force
pushing is acceptable. Rewriting history changes commit hashes.

For repositories that use `main`:

```bash
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --env-filter '
CORRECT_NAME="awkwardsky"
CORRECT_EMAIL="9321793+awkwardsky@users.noreply.github.com"
export GIT_AUTHOR_NAME="$CORRECT_NAME"
export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
export GIT_COMMITTER_NAME="$CORRECT_NAME"
export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
' main

git update-ref -d refs/original/refs/heads/main 2>/dev/null || true
git push --force-with-lease origin main
```

For `awkwardsky.github.io`, use `master` instead:

```bash
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --env-filter '
CORRECT_NAME="awkwardsky"
CORRECT_EMAIL="9321793+awkwardsky@users.noreply.github.com"
export GIT_AUTHOR_NAME="$CORRECT_NAME"
export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
export GIT_COMMITTER_NAME="$CORRECT_NAME"
export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
' master

git update-ref -d refs/original/refs/heads/master 2>/dev/null || true
git push --force-with-lease origin master
```

## Remote Verification

After pushing, verify GitHub sees the commit as `awkwardsky`:

```bash
curl -sS https://api.github.com/repos/awkwardsky/REPO_NAME/commits/BRANCH_NAME \
  | jq -r '[.sha[0:7], .commit.author.name, .commit.author.email, (.author.login // "-")] | @tsv'
```

Example:

```bash
curl -sS https://api.github.com/repos/awkwardsky/ReactionSpeedLab/commits/main \
  | jq -r '[.sha[0:7], .commit.author.name, .commit.author.email, (.author.login // "-")] | @tsv'
```

Expected author login:

```text
awkwardsky
```
