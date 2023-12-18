microservices=( "metadata-nodejs" "processdata-python" )
#microservices=`while IFS= read -r DIR; do echo "${DIR}"; done < <(find ./src -maxdepth 1 -type d -printf "%P\n")`

for item in "${microservices[@]}"
do
    echo $item
    change=`git log -1 --name-status | grep $item`
    
    
    if [ -z "$change" ]
    then
          echo "code not changed in $item ==================="
    else
          echo "code changed in $item ======================"
          cd src/$item
          docker build -t containerized-lambda-$item .
          docker tag containerized-lambda-$item $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO_NAME:containerized-lambda-$item-$CODEBUILD_BUILD_NUMBER
          docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO_NAME:containerized-lambda-$item-$CODEBUILD_BUILD_NUMBER
          cd ../..
          #LAMBDA_IMAGE_URI=$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO_NAME:containerized-lambda-$item-$CODEBUILD_BUILD_NUMBER
    fi
done
