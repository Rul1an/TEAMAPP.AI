# Performance Badges

## Overview

Performance badges provide quick visual indicators of the application's performance status. These badges are automatically updated based on CI/CD pipeline results and can be embedded in documentation or README files.

## Available Badges

### 1. Performance Score Badge

**URL**: `https://img.shields.io/badge/Performance-85%25-brightgreen`

**Status**:
- 🟢 Bright Green: ≥85%
- 🟡 Yellow: 70-84%
- 🔴 Red: <70%

### 2. Lighthouse Score Badge

**URL**: `https://img.shields.io/badge/Lighthouse-92-brightgreen`

**Status**:
- 🟢 Bright Green: ≥90
- 🟡 Yellow: 80-89
- 🔴 Red: <80

### 3. Memory Leak Status Badge

**URL**: `https://img.shields.io/badge/Memory%20Leaks-None-brightgreen`

**Status**:
- 🟢 Bright Green: No leaks detected
- 🔴 Red: Leaks detected

### 4. Web Vitals Status Badge

**URL**: `https://img.shields.io/badge/Web%20Vitals-Pass-brightgreen`

**Status**:
- 🟢 Bright Green: All vitals pass
- 🟡 Yellow: Some vitals need improvement
- 🔴 Red: Critical vitals failing

### 5. Build Status Badge

**URL**: `https://img.shields.io/badge/Build-Passing-brightgreen`

**Status**:
- 🟢 Bright Green: All checks pass
- 🔴 Red: Build failed

## Implementation

### GitHub Actions Integration

The badges are automatically updated in the CI/CD pipeline:

```yaml
# .github/workflows/advanced-deployment.yml
- name: 📊 Update Performance Badges
  run: |
    # Update badge based on Lighthouse results
    if [ $LIGHTHOUSE_SCORE -ge 85 ]; then
      BADGE_COLOR="brightgreen"
      BADGE_TEXT="Pass"
    else
      BADGE_COLOR="red"
      BADGE_TEXT="Fail"
    fi

    # Generate badge URL
    BADGE_URL="https://img.shields.io/badge/Performance-$BADGE_TEXT-$BADGE_COLOR"
    echo "Performance Badge: $BADGE_URL"
```

### Badge Generation Script

```bash
#!/bin/bash
# scripts/generate-badges.sh

# Performance Score Badge
PERFORMANCE_SCORE=$(cat lighthouse-report.json | jq -r '.categories.performance.score * 100 | round')
if [ $PERFORMANCE_SCORE -ge 85 ]; then
    COLOR="brightgreen"
elif [ $PERFORMANCE_SCORE -ge 70 ]; then
    COLOR="yellow"
else
    COLOR="red"
fi

echo "![Performance](https://img.shields.io/badge/Performance-${PERFORMANCE_SCORE}%25-${COLOR})"

# Memory Leak Badge
if [ -f "memory-leak-report.json" ]; then
    LEAK_COUNT=$(cat memory-leak-report.json | jq '.leaks | length')
    if [ $LEAK_COUNT -eq 0 ]; then
        echo "![Memory Leaks](https://img.shields.io/badge/Memory%20Leaks-None-brightgreen)"
    else
        echo "![Memory Leaks](https://img.shields.io/badge/Memory%20Leaks-${LEAK_COUNT}%20Found-red)"
    fi
fi
```

## Usage in Documentation

### README.md

```markdown
# JO17 Tactical Manager

![Performance](https://img.shields.io/badge/Performance-85%25-brightgreen)
![Lighthouse](https://img.shields.io/badge/Lighthouse-92-brightgreen)
![Memory Leaks](https://img.shields.io/badge/Memory%20Leaks-None-brightgreen)
![Web Vitals](https://img.shields.io/badge/Web%20Vitals-Pass-brightgreen)
![Build](https://img.shields.io/badge/Build-Passing-brightgreen)

A tactical management application for football teams.
```

### Performance Dashboard

```markdown
# Performance Dashboard

## Current Status

| Metric | Status | Score |
|--------|--------|-------|
| Performance | ![Performance](https://img.shields.io/badge/Performance-85%25-brightgreen) | 85% |
| Accessibility | ![Accessibility](https://img.shields.io/badge/Accessibility-95%25-brightgreen) | 95% |
| Best Practices | ![Best Practices](https://img.shields.io/badge/Best%20Practices-88%25-brightgreen) | 88% |
| SEO | ![SEO](https://img.shields.io/badge/SEO-92%25-brightgreen) | 92% |

## Core Web Vitals

| Vital | Status | Value |
|-------|--------|-------|
| LCP | ![LCP](https://img.shields.io/badge/LCP-1.2s-brightgreen) | 1.2s |
| FID | ![FID](https://img.shields.io/badge/FID-45ms-brightgreen) | 45ms |
| CLS | ![CLS](https://img.shields.io/badge/CLS-0.05-brightgreen) | 0.05 |
```

## Custom Badges

### Team Performance Badge

```markdown
![Team Performance](https://img.shields.io/badge/Team%20Performance-Excellent-brightgreen)
```

### Code Quality Badge

```markdown
![Code Quality](https://img.shields.io/badge/Code%20Quality-A%2B-brightgreen)
```

### Test Coverage Badge

```markdown
![Test Coverage](https://img.shields.io/badge/Test%20Coverage-78%25-yellow)
```

## Badge Configuration

### Colors

- `brightgreen`: Excellent performance (≥85%)
- `green`: Good performance (75-84%)
- `yellow`: Needs improvement (60-74%)
- `orange`: Poor performance (40-59%)
- `red`: Critical issues (<40%)

### Text Formatting

- Use `%20` for spaces in URLs
- Use `%25` for percentage signs
- Keep text concise and readable

## Automation

### Scheduled Updates

Badges are updated:
- After each deployment
- Daily performance checks
- Weekly memory leak scans
- Monthly performance reviews

### Manual Updates

To manually update badges:

```bash
# Run badge generation
./scripts/generate-badges.sh

# Update documentation
./scripts/update-docs.sh
```

## Monitoring

### Badge Health

Monitor badge availability:
- Check badge URLs regularly
- Verify color accuracy
- Ensure text readability
- Test in different environments

### Performance Tracking

Track badge trends over time:
- Performance score history
- Lighthouse score progression
- Memory leak frequency
- Web vitals improvements

## Best Practices

1. **Keep badges current** - Update after each deployment
2. **Use consistent colors** - Follow the defined color scheme
3. **Make text readable** - Use clear, concise labels
4. **Monitor accuracy** - Verify badge data matches reality
5. **Document thresholds** - Explain what each color means

## Troubleshooting

### Badge Not Updating

1. Check CI/CD pipeline status
2. Verify badge generation script
3. Review GitHub Actions logs
4. Test badge URL manually

### Incorrect Colors

1. Verify performance thresholds
2. Check badge generation logic
3. Review Lighthouse results
4. Validate data sources

### Broken Badges

1. Check shields.io service status
2. Verify URL formatting
3. Test with different browsers
4. Check network connectivity
