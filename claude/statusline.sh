#!/usr/bin/env bash
# Claude Code status line: model | git branch | context usage %
input=$(cat)

model=$(jq -r '.model.display_name // "?"' <<<"$input")
dir=$(jq -r '.workspace.current_dir // .cwd // "?"' <<<"$input")
tokens=$(jq -r '.context_window.total_input_tokens // empty' <<<"$input")
ctx_max=$(jq -r '.context_window.context_window // empty' <<<"$input")

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
  if [ -n "$ctx_max" ] && [ "$ctx_max" -ge 500000 ]; then
    t_bright=200000; t_red=150000; t_yellow=100000
  else
    t_bright=120000; t_red=90000; t_yellow=60000
  fi
  if [ "$tokens" -ge "$t_bright" ]; then
    color=$bright_red
  elif [ "$tokens" -ge "$t_red" ]; then
    color=$red
  elif [ "$tokens" -ge "$t_yellow" ]; then
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
