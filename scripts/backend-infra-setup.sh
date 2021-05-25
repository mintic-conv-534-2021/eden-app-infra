#!/bin/bash

CLUSTER_NAME=eden-app-backend-poc
REPO_NAME=eden-app-repo-poc
AWS_REGION=us-west-2

#check for needed commands
command -v eksctl >/dev/null 2>&1 || { echo >&2 "I require eksctl but it's not installed.  Aborting."; exit 1; }
command -v aws >/dev/null 2>&1 || { echo >&2 "I require the aws cli but it's not installed.  Aborting."; exit 1; }
command -v jq >/dev/null 2>&1 || { echo >&2 "I require jq but it's not installed.  Aborting."; exit 1; }
command -v helm >/dev/null 2>&1 || { echo >&2 "I require helm but it's not installed.  Aborting."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo >&2 "I require kubectl but it's not installed.  Aborting."; exit 1; }


echo "Inicia creación de clúster EKS"
#https://aws.amazon.com/es/blogs/opensource/kubernetes-ingress-aws-alb-ingress-controller/
# updated by
# https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/deploy/installation/

# ejemplo base de: https://nubisoft.io/blog/how-to-set-up-kubernetes-ingress-with-aws-alb-ingress-controller/

# eksctl create cluster --name $CLUSTER_NAME --region $AWS_REGION

eksctl utils associate-iam-oidc-provider \
            --region $AWS_REGION \
            --cluster $CLUSTER_NAME \
            --approve

# eksctl utils associate-iam-oidc-provider \
#            --region us-west-2 \
#            --cluster eden-app-backend-poc \
#            --approve

curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.0/docs/install/iam_policy.json

aws iam create-policy \
            --policy-name AWSLoadBalancerControllerIAMPolicy \
            --policy-document file://iam-policy.json

POLICY_EXISTING=$(aws iam list-policies | jq -r '.[][] | select(.PolicyName=="AWSLoadBalancerControllerIAMPolicy") | .Arn')
if [ $POLICY_EXISTING ]
then
POLICY_ARN=$POLICY_EXISTING;
else
POLICY_ARN=$(aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam-policy.json | jq -r '.Policy.Arn')
fi

eksctl create iamserviceaccount \
            --cluster=$CLUSTER_NAME \
            --region=$AWS_REGION \
            --namespace=kube-system \
            --name=aws-load-balancer-controller \
            --attach-policy-arn=$POLICY_ARN \
            --override-existing-serviceaccounts \
            --approve


# eksctl create iamserviceaccount \
#            --cluster=eden-app-backend-poc \
#            --region=us-west-2 \
#            --namespace=kube-system \
#            --name=aws-load-balancer-controller \
#            --attach-policy-arn=arn:aws:iam::017777727880:policy/AWSLoadBalancerControllerIAMPolicy \
#            --override-existing-serviceaccounts \
#            --approve

helm repo add eks https://aws.github.io/eks-charts

kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=$CLUSTER_NAME --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

#helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=eden-app-backend-poc --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

echo "Inicia creación de repositorio de imagenes docker privado"

aws ecr create-repository --repository-name $REPO_NAME --region $AWS_REGION

#aws ecr create-repository --repository-name eden-app-repo-poc --region us-west-2