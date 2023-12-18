microservices=( "metadata-nodejs" "processdata-python" )

for item in "${microservices[@]}"
do
    echo $item
    change=`git log -1 --name-status | grep $item`
    
    if [ "$ENV" = "dev" ]
    then
        LAMBDA_IMAGE_URI=$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO_NAME:containerized-lambda-$item-$CODEBUILD_BUILD_NUMBER
    elif [ "$ENV" = "prod" ]
    then
        LAMBDA_IMAGE_URI=$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO_NAME:containerized-lambda-$item-$DEVBUILD_BUILD_NUMBER
    else
        echo "Environment not found"
    fi
    
    if [ -z "$change" ]
    then
          echo "code not changed in $item ==================="
    else
          echo "code changed in $item ======================"
          aws cloudformation package --template-file deploy/templates/lambda_$item.yml --output-template-file package_$item.yml --s3-bucket codepipeline-ap-south-1-349545785268
          aws cloudformation deploy --template-file package_$item.yml --stack-name LambdaContainerized-$item-$ENV --parameter-overrides LambdaImageUri=$LAMBDA_IMAGE_URI LambdaRoleArn=arn:aws:iam::175947708553:role/LambdaContainerizedRole Environment=$ENV --capabilities CAPABILITY_IAM --no-fail-on-empty-changeset

    fi
done

