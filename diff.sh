set -ex

# For testing.
# SLACK_WEBHOOK=https://hooks.slack.com/services/... TARGET_BRANCH=prod NAME=rive-app/rive WORKSPACE=../rive GITHUB_REF=refs/heads/master ./diff.sh

# Get the hash of the repo.
ACTIVE_BRANCH=${GITHUB_REF##*/}
cd $WORKSPACE

# https://stackoverflow.com/questions/58033366/how-to-get-the-current-branch-within-github-actions
git fetch
echo $(git rev-list --left-right --count origin/$TARGET_BRANCH...origin/$ACTIVE_BRANCH)
DIFF_COUNT=$(git fetch && git rev-list --left-right --count origin/$TARGET_BRANCH...origin/$ACTIVE_BRANCH | awk '{print $2}')
echo $DIFF_COUNT

echo "Diff count is $DIFF_COUNT"

if [ "$DIFF_COUNT" == "0" ]
then 
    echo "No diff, all is good"
else 
    DIFF_URL=https://github.com/$NAME/compare/$TARGET_BRANCH...$ACTIVE_BRANCH

    # NOTE: not adding this message at the moment. its pretty spammy. 
    # MESSAGE=$(git log --color --graph --pretty=format:'%h -%d %s (%cr) <%an>' --abbrev-commit  --left-right origin/$TARGET_BRANCH...origin/$ACTIVE_BRANCH)
    # echo $MESSAGE

    # Just full on assuming this is behind for the time being. 
    # Could put in some 'useful' links into this message. Once we have something useful to do (other than update & rebuild)
    curl -X POST -H 'Content-type: application/json' --data '{"text":" `'$NAME'`: `'$TARGET_BRANCH'` is behind `'$ACTIVE_BRANCH'` by <'$DIFF_URL'|'$DIFF_COUNT' commit(s)>."}' $SLACK_WEBHOOK
fi 