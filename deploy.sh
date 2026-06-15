#!/bin/bash

# ─────────────────────────────────────────
# Apex OneStop — Deploy to GitHub + Netlify
# Usage: ./deploy.sh "your commit message"
# ─────────────────────────────────────────

PROJECT_DIR=~/Downloads/apex-onestop
MSG=${1:-"update: $(date '+%Y-%m-%d %H:%M')"}

echo ""
echo "🚀 Apex Deploy"
echo "──────────────"
echo "Folder : $PROJECT_DIR"
echo "Message: $MSG"
echo ""

if [ ! -d "$PROJECT_DIR" ]; then
  echo "❌ Folder not found: $PROJECT_DIR"
  exit 1
fi

cd "$PROJECT_DIR"

if [ ! -d ".git" ]; then
  echo "❌ Not a git repo. Run 'git init' first."
  exit 1
fi

echo "📦 Staging changes..."
git add -A

echo "💾 Committing..."
git commit -m "$MSG"

if [ $? -ne 0 ]; then
  echo "⚠️  Nothing new to commit."
  exit 0
fi

echo "⬆️  Pushing to GitHub..."
git push

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ Done! Netlify will deploy in ~30 seconds."
  echo "🌐 https://apex-onestop-v2.netlify.app"
  echo ""
else
  echo ""
  echo "❌ Push failed. Check your internet or SSH key."
  echo ""
  exit 1
fi
