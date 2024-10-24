#!/bin/bash
FILE=$1
if [[ ! -f $FILE ]];then
    echo "$FILE does not exist"
    exit 1
fi
which aws
if [[ $? != 0 ]];then
    SYSTEM=$(uname)
    if [[ $SYSTEM == "Linux" ]];then
            sudo apt-get install -y awscli
    elif [[ $SYSTEM == "Darwin" ]]; then
        brew install awscli
    else
        echo "Unable to determine operating systm"
        exit 1
    fi
fi
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set region auto
aws s3 cp $FILE s3://$BUCKET/ --endpoint-url https://$ACCOUNT.r2.cloudflarestorage.com
