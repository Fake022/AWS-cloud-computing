STACKNAME_BASE="my-pdf-dev"
# This is a region that supports AWS Fargate
REGION="eu-west-2"
PROFILE="default"
IMAGE_NAME="my_sls_scraper"

build:
	docker build -t $(IMAGE_NAME):latest .

retag:
	docker tag $(IMAGE_NAME):latest \
		$(shell aws cloudformation --region $(REGION) --profile $(PROFILE) describe-stacks --stack-name $(STACKNAME_BASE) --query "Stacks[0].Outputs[?OutputKey=='ECRRepo'].OutputValue" --output text):latest
	@exec $(shell aws ecr --region $(REGION) --profile $(PROFILE) get-authorization-token --no-include-email)
	docker push $(shell aws cloudformation --region $(REGION) --profile $(PROFILE) describe-stacks --stack-name $(STACKNAME_BASE) --query "Stacks[0].Outputs[?OutputKey=='ECRRepo'].OutputValue" --output text):latest