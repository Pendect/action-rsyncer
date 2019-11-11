#!/bin/sh -l
set -e

SSH_PATH="$HOME/.ssh"

mkdir -p "$SSH_PATH"
touch "$SSH_PATH/known_hosts"

# echo -e "$DEPLOY_KEY" > "$SSH_PATH/deploy_key"
printf '%b\n' "$DEPLOY_KEY" > "$SSH_PATH/deploy_key"

chmod 700 "$SSH_PATH"
chmod 600 "$SSH_PATH/known_hosts" "$SSH_PATH/deploy_key"

eval "$(ssh-agent)"
ssh-add "$SSH_PATH/deploy_key"

if ! sh -c "rsync $1 -e 'ssh -i $SSH_PATH/deploy_key -o StrictHostKeyChecking=no' $2 $GITHUB_WORKSPACE/$3 $4"
then
  echo ::set-output name=status::'There was an issue syncing the content.'
  exit 1
else
  echo ::set-output name=status::'Content synced successfully.'
fi
