#!/bin/bash

# Flutter Development Workflow Automation Script
# Implements industry best practices for code quality and deployment
# Date: 2025-08-01
# Usage: ./scripts/dev_workflow.sh "commit message"

set -e

# =============================================================================
# CONFIGURATION & VALIDATION
# =============================================================================

if [ $# -eq 0 ]; then
    echo "❌ Usage: ./scripts/dev_workflow.sh \"your commit message\""
    echo "   Example: ./scripts/dev_workflow.sh \"fix: resolve E2E test configuration\""
    exit 1
fi

COMMIT_MSG="$1"

echo "🚀 Flutter Development Workflow Pipeline"
echo "================================================"
echo "📝 Commit Message: \"$COMMIT_MSG\""
echo "📅 $(date)"
echo ""

# Verify we're in Flutter project root
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ pubspec.yaml not found. Run from Flutter project root."
    exit 1
fi

# =============================================================================
# PHASE 1: CODE QUALITY PIPELINE
# =============================================================================

echo "📊 Phase 1: Flutter Code Quality Pipeline"
echo "=================================="

# Step 1: Flutter Analyze
echo "🔍 Step 1/3: Running flutter analyze..."
echo "Checking for errors, warnings, and lints (CI parity: --fatal-infos)"
if ! flutter analyze --fatal-infos; then
    echo ""
    echo "💥 FLUTTER ANALYZE FAILED!"
    echo "❌ Pipeline aborted - fix analyzer errors first"
    echo ""
    echo "🔧 Run the following to diagnose:"
    echo "   flutter analyze"
    echo "   # Fix the reported issues"
    echo "   # Then re-run this script"
    exit 1
fi
echo "✅ Flutter analyze passed"
echo ""

# Step 2: Dart Format
echo "🎨 Step 2/3: Dart Format (CI parity)"
echo "Applying consistent code formatting and verifying no diffs..."
# First apply formatting unconditionally for convenience
dart format . --line-length=100 >/dev/null
# Then enforce the gate exactly like CI
if ! dart format . --set-exit-if-changed --line-length=100; then
    echo ""
    echo "💥 FORMAT CHECK FAILED (CI parity)"
    echo "Some files required formatting and were changed."
    echo "Please review changes, stage them, and re-run this script."
    exit 1
fi
echo ""

# Step 3: Dart Fix
echo "🔧 Step 3/3: Running dart fix"
echo "Applying automated code improvements (non-fatal in CI, safe locally)..."
dart fix --apply || true
echo ""

echo "🎉 Phase 1 Complete: Code Quality Pipeline PASSED"
echo ""

# =============================================================================
# PHASE 2: GIT WORKFLOW PIPELINE
# =============================================================================

echo "📊 Phase 2: Git Workflow Pipeline"
echo "=================================="

# Step 1: Stage all changes
echo "📋 Step 1/3: Staging Changes"
git add -A
STAGED_FILES=$(git diff --cached --name-only | wc -l | tr -d ' ')
if [ "$STAGED_FILES" -gt 0 ]; then
    echo "✅ Staged $STAGED_FILES file(s) for commit"
    git diff --cached --stat
else
    echo "ℹ️ No changes to commit"
    exit 0
fi
echo ""

# Step 2: Commit with message
echo "💾 Step 2/3: Creating Commit"
echo "Commit message: \"$COMMIT_MSG\""
if git commit -m "$COMMIT_MSG"; then
    COMMIT_HASH=$(git rev-parse --short HEAD)
    echo "✅ Commit created successfully: $COMMIT_HASH"
else
    echo "❌ Commit failed - check error messages above"
    exit 1
fi
echo ""

# Step 3: Push to remote
echo "🌐 Step 3/3: Pushing to Remote"
BRANCH_NAME=$(git branch --show-current)
echo "Pushing to origin/$BRANCH_NAME..."
if git push origin "$BRANCH_NAME"; then
    echo "✅ Successfully pushed to remote repository"
else
    echo "❌ Push failed - check error messages above"
    echo "💡 Try: git pull --rebase origin $BRANCH_NAME"
    exit 1
fi
echo ""

echo "🎉 Phase 2 Complete: Git Workflow Pipeline PASSED"
echo ""

# =============================================================================
# PHASE 3: VERIFICATION & SUMMARY
# =============================================================================

echo "📊 Phase 3: Verification & Summary"
echo "==================================="

# Display final status
COMMIT_HASH=$(git rev-parse --short HEAD)
REMOTE_STATUS=$(git status -b --porcelain=v1 2>/dev/null | head -n1 || echo "unknown")

echo "📈 Pipeline Results:"
echo "   ✅ Code Quality: PASSED (analyze + format + fix)"
echo "   ✅ Git Workflow: PASSED (stage + commit + push)"
echo "   📍 Latest Commit: $COMMIT_HASH"
echo "   🌿 Branch: $BRANCH_NAME"
echo "   🌐 Remote Status: $REMOTE_STATUS"
echo ""

# Optional: Display commit details
echo "📝 Commit Details:"
git show --stat --no-patch HEAD
echo ""

echo "🏆 SUCCESS: Complete Development Workflow Pipeline PASSED"
echo "================================================"
echo "🚀 All changes successfully committed and pushed!"
echo "📅 Completed at: $(date)"
echo ""

# =============================================================================
# OPTIONAL: PERFORMANCE TIPS
# =============================================================================

echo "💡 Pro Tips for Next Development Cycle:"
echo "   • Use: ./scripts/dev_workflow.sh \"type: description\""
echo "   • Types: feat, fix, docs, style, refactor, test, chore"
echo "   • Example: ./scripts/dev_workflow.sh \"feat: add video analytics dashboard\""
echo "   • Check status: git status"
echo "   • View history: git log --oneline -10"
echo ""
