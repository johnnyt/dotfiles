#!/usr/bin/env bash
# Claude Code status line: model | git branch | context usage %
input=$(cat)

model=$(jq -r '.model.display_name // "?"' <<<"$input")
dir=$(jq -r '.workspace.current_dir // .cwd // "?"' <<<"$input")
tokens=$(jq -r '.context_window.total_input_tokens // empty' <<<"$input")

branch=""
if [ -d "$dir/.git" ] || git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$dir" branch --show-current 2>/dev/null)
fi

reset=$'\033[0m'
green=$'\033[32m'
yellow=$'\033[33m'
red=$'\033[31m'
bright_red=$'\033[1;31m'
dim=$'\033[2m'

if [ -n "$tokens" ]; then
  if [ "$tokens" -ge 200000 ]; then
    color=$bright_red
  elif [ "$tokens" -ge 150000 ]; then
    color=$red
  elif [ "$tokens" -ge 100000 ]; then
    color=$yellow
  else
    color=$green
  fi
  tokens_k=$((tokens / 1000))
  ctx="${color}ctx ${tokens_k}k${reset}"
else
  ctx="${dim}ctx --${reset}"
fi

line="${dim}${model}${reset}"
if [ -n "$branch" ]; then
  line="${line} ${dim}|${reset} ${branch}"
fi
line="${line} ${dim}|${reset} ${ctx}"

printf '%s' "$line"
