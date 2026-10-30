---
name: create-pull-request
description: This skill should be used when the user asks to create a pull request.
---

# Create Pull Request

Create well-documented pull requests with comprehensive descriptions.

## Behavior
1. Analyze commits since branching from main.
2. Generate a descriptive PR title no longer than 85 symbols. Use headline style.
3. Create a description with:
    - Short summary.
    - List of changes.

## PR Template
```markdown
## Summary
Brief description of changes. No longer than 2-3 sentences.

## Changes
- List of specific changes made.
```

## Requirements
- GitHub CLI (`gh`) installed and authenticated.
- On a feature branch (not master).
