.DEFAULT_GOAL := help

STACK_NAME ?= aws-cognito-temp2
PROJECT_NAME ?= aws-sam-cog-temp2
ENV ?= unstable
AWS_BUCKET_NAME ?= cognito-bucket-temp2
REGION ?= us-west-2

help:
	@echo Available tasks:
	@echo	package		Upload any artifacts that your Lambda application requires to an AWS S3 bucket.
	@echo deploy
	@echo create-bucket

create-bucket:
	@echo "Create Bucket"
	aws s3api create-bucket \
	--bucket $(AWS_BUCKET_NAME) \
	--region $(REGION) \
	--create-bucket-configuration LocationConstraint=$(REGION)

package:
	@echo	"Package task triggered"
	aws cloudformation package \
  --template-file template.yml \
  --output-template-file package.yml \
  --s3-bucket $(AWS_BUCKET_NAME)

deploy:
	@echo	"Deploy task triggered"
	aws cloudformation deploy \
  --template-file package.yml \
  --stack-name $(STACK_NAME) \
  --capabilities CAPABILITY_IAM	\
	--parameter-overrides \
			ParamProjectName=$(PROJECT_NAME) \
			ParamENV=$(ENV)	\
			ParamBucket=$(AWS_BUCKET_NAME)
