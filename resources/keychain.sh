if [ ! -z $SSH_PRIVATE_KEY ]
then 
    /usr/bin/keychain -q --nogui $SSH_PRIVATE_KEY
    source $HOME/.keychain/$HOSTNAME-sh
fi 
