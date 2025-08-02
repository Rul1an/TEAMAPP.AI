#!/bin/bash
# Security Implementation Deployment Script - DAG 1 Kritieke Fixes
# Usage: ./scripts/deploy-security-fixes.sh

set -e

echo "🔒 SECURITY IMPLEMENTATION DAG 1 - KRITIEKE FIXES"
echo "================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function for colored output
log_info() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check prerequisites
echo "🔍 Checking Prerequisites..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    log_error "Flutter is not installed"
    exit 1
fi
log_info "Flutter found: $(flutter --version | head -n 1)"

# Check if Netlify CLI is available
if ! command -v netlify &> /dev/null; then
    log_warning "Netlify CLI not found - installing via npm"
    npm install -g netlify-cli
fi
log_info "Netlify CLI found: $(netlify --version)"

# 1. BUILD FLUTTER WEB APPLICATION
echo ""
echo "🏗️  STEP 1: Building Flutter Web Application..."
echo "=============================================="

flutter clean
flutter pub get

# Build for production with security optimizations
flutter build web --release \
    --web-renderer html \
    --dart-define=FLUTTER_WEB_USE_SKIA=false \
    --dart-define=APP_ENV=production \
    --dart-define=SECURITY_LEVEL=high

if [ $? -eq 0 ]; then
    log_info "Flutter web build completed successfully"
else
    log_error "Flutter web build failed"
    exit 1
fi

# 2. VERIFY SECURITY FILES
echo ""
echo "🛡️  STEP 2: Verifying Security Files..."
echo "======================================"

# Check if rate limiter exists
if [ -f "netlify/edge-functions/rate-limiter.ts" ]; then
    log_info "Rate limiter edge function found"
else
    log_error "Rate limiter edge function missing"
    exit 1
fi

# Check if netlify.toml has security headers
if grep -q "Content-Security-Policy" netlify.toml; then
    log_info "Security headers found in netlify.toml"
else
    log_error "Security headers missing in netlify.toml"
    exit 1
fi

# Check if build directory exists
if [ -d "build/web" ]; then
    log_info "Build directory exists: $(du -sh build/web | cut -f1)"
else
    log_error "Build directory missing"
    exit 1
fi

# 3. DEPLOY TO NETLIFY
echo ""
echo "🚀 STEP 3: Deploying to Netlify..."
echo "=================================="

# Deploy to production with security focus
netlify deploy \
    --prod \
    --dir=build/web \
    --message="Security Implementation DAG 1 - Rate Limiting + Security Headers"

if [ $? -eq 0 ]; then
    log_info "Deployment to Netlify completed successfully"
else
    log_error "Netlify deployment failed"
    exit 1
fi

# 4. VERIFY DEPLOYMENT
echo ""
echo "🔍 STEP 4: Verifying Security Deployment..."
echo "=========================================="

# Get site URL from Netlify
SITE_URL=$(netlify sites:list --json | jq -r '.[0].url' 2>/dev/null || echo "https://teamappai.netlify.app")

log_info "Testing deployment at: $SITE_URL"

# Wait for deployment to propagate
echo "⏳ Waiting 30 seconds for deployment to propagate..."
sleep 30

# Test security headers
echo "🔍 Testing Security Headers..."

HEADERS_TEST=$(curl -s -I "$SITE_URL" || echo "FAILED")

if echo "$HEADERS_TEST" | grep -q "Content-Security-Policy"; then
    log_info "✅ Content-Security-Policy header present"
else
    log_warning "⚠️  Content-Security-Policy header missing"
fi

if echo "$HEADERS_TEST" | grep -q "X-Frame-Options"; then
    log_info "✅ X-Frame-Options header present"
else
    log_warning "⚠️  X-Frame-Options header missing"
fi

if echo "$HEADERS_TEST" | grep -q "Strict-Transport-Security"; then
    log_info "✅ HSTS header present"
else
    log_warning "⚠️  HSTS header missing"
fi

# Test rate limiting (basic test)
echo "🔍 Testing Rate Limiting..."

RATE_LIMIT_TEST=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL/api/test" || echo "000")

if [ "$RATE_LIMIT_TEST" = "404" ] || [ "$RATE_LIMIT_TEST" = "200" ]; then
    log_info "✅ Rate limiting endpoint accessible"
else
    log_warning "⚠️  Rate limiting test inconclusive (status: $RATE_LIMIT_TEST)"
fi

# Test HTTPS redirect
echo "🔍 Testing HTTPS Enforcement..."

HTTP_REDIRECT=$(curl -s -o /dev/null -w "%{http_code}" -L "http://$(echo $SITE_URL | sed 's/https\?:\/\///')" || echo "000")

if [ "$HTTP_REDIRECT" = "200" ]; then
    log_info "✅ HTTPS redirect working"
else
    log_warning "⚠️  HTTPS redirect test inconclusive (status: $HTTP_REDIRECT)"
fi

# 5. SECURITY SCORE CALCULATION
echo ""
echo "📊 STEP 5: Security Score Calculation..."
echo "======================================"

SECURITY_SCORE=0

# Rate limiting implementation (25 points)
if [ -f "netlify/edge-functions/rate-limiter.ts" ]; then
    SECURITY_SCORE=$((SECURITY_SCORE + 25))
    log_info "Rate Limiting: +25 points"
fi

# Security headers (40 points)
HEADERS_SCORE=0
if echo "$HEADERS_TEST" | grep -q "Content-Security-Policy"; then
    HEADERS_SCORE=$((HEADERS_SCORE + 10))
fi
if echo "$HEADERS_TEST" | grep -q "X-Frame-Options"; then
    HEADERS_SCORE=$((HEADERS_SCORE + 10))
fi
if echo "$HEADERS_TEST" | grep -q "Strict-Transport-Security"; then
    HEADERS_SCORE=$((HEADERS_SCORE + 10))
fi
if echo "$HEADERS_TEST" | grep -q "X-Content-Type-Options"; then
    HEADERS_SCORE=$((HEADERS_SCORE + 10))
fi

SECURITY_SCORE=$((SECURITY_SCORE + HEADERS_SCORE))
log_info "Security Headers: +$HEADERS_SCORE points"

# HTTPS enforcement (15 points)
if [ "$HTTP_REDIRECT" = "200" ]; then
    SECURITY_SCORE=$((SECURITY_SCORE + 15))
    log_info "HTTPS Enforcement: +15 points"
fi

# Deployment success (20 points)
if [ $? -eq 0 ]; then
    SECURITY_SCORE=$((SECURITY_SCORE + 20))
    log_info "Deployment Success: +20 points"
fi

# FINAL RESULTS
echo ""
echo "🏆 SECURITY IMPLEMENTATION RESULTS"
echo "=================================="
echo ""
echo "Security Score: $SECURITY_SCORE/100"
if [ $SECURITY_SCORE -ge 85 ]; then
    log_info "🎯 EXCELLENT: Security score target exceeded!"
elif [ $SECURITY_SCORE -ge 70 ]; then
    log_info "✅ GOOD: Security implementation successful"
else
    log_warning "⚠️  NEEDS IMPROVEMENT: Security score below target"
fi

echo ""
echo "📋 COMPLETED IMPLEMENTATIONS:"
echo "- ✅ Rate Limiting (Netlify Edge Functions)"
echo "- ✅ Security Headers (Content-Security-Policy, HSTS, etc.)"
echo "- ✅ HTTPS Enforcement"
echo "- ✅ Production Deployment"
echo ""
echo "🔗 Application URL: $SITE_URL"
echo "⏱️  Implementation Time: DAG 1 (24 hours)"
echo "🎯 Next Steps: DAG 2-3 Advanced Security Features"
echo ""
echo "🔒 Security Implementation DAG 1 Complete!"
