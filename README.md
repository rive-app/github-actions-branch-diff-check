# Description

A simple diff checker that keeps a lid on branch diffs.

Use this to make sure the branch you run this check on does not diverge from the target branch too much.

## Parameters

Just look at the `action.yml` itself, it's <30 lines of code, and will stay up to date.

## How to (by example)

```yaml
name: Notify diffs between main branch and target branch.

on:
  schedule:
    # 8am UTC every day, will run against the default / main branch
    - cron:  '0 8 * * *'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v2

      - name: Run cpp version check
        uses: rive-app/github-actions-branch-diff-check@v1
        with:
          SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK }}
          TARGET_BRANCH: prod
```
