#!/bin/sh -x

set -e
if [ "$#" -lt 1 ]
then
echo  "Please specify the S3 bucket you will be uploading to."
exit
else
echo -e "\c"
fi

bucket_name=$1

for layer in ./python/* #$(ls ./python)
do

mkdir -p $layer/python/lib/python3.8/site-packages/
pip3 install -t $layer/python/lib/python3.8/site-packages/ -r $layer/requirements.txt

done

aws cloudformation package --template-file template.yaml --s3-bucket $bucket_name --s3-prefix layers > packaged.yaml
aws cloudformation deploy --stack-name LambdaLayers --template ./packaged.yaml
rm packaged.yaml
