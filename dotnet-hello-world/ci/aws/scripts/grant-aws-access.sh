#!/usr/bin/env bash

NAME="appvia-workshop-admin"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
AWS_MAX_SESSION_DURATION="43200"

usage() { echo "Usage: $0 [ -u USER_NAME ]" 1>&2; exit 1; }

while getopts ":u:h" opt; do
  case ${opt} in
    h )
      usage
      ;;
    u )
      USER_NAME=$OPTARG
      ;;
    : )
      echo "Error: -${OPTARG} requires an argument."
      usage
      ;;
    \? )
      echo "Error: -${OPTARG} is an invalid option."
      usage
      ;;
    * )
      usage
      ;;
  esac
done

log()   { (2>/dev/null echo -e "$@"); }
info()  { log "[info]  $@"; }

create_role() {
  if ! aws iam get-role --role-name ${NAME}-role >/dev/null 2>&1; then
    info "Creating IAM role ${NAME}-role"
    aws iam create-role --role-name ${NAME}-role \
    --assume-role-policy-document "{\"Version\":\"2012-10-17\",\"Statement\":{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::${AWS_ACCOUNT_ID}:root\"},\"Action\":\"sts:AssumeRole\"}}" \
    --max-session-duration ${AWS_MAX_SESSION_DURATION}
  fi
}

create_iam_policy() {
  if ! aws iam get-policy --policy-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${NAME}-policy" >/dev/null 2>&1; then
    info "Creating IAM policy ${NAME}-policy"
    aws iam create-policy --policy-name ${NAME}-policy --policy-document file://iam-role-policy.json
  else
    info "Updating IAM policy ${NAME}-policy"
    aws iam create-policy-version --policy-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${NAME}-policy" --policy-document file://iam-role-policy.json --set-as-default
  fi
}

attach_role_policy() {
  POLICY_ARN=$(aws iam list-attached-role-policies \
  --role-name ${NAME}-role \
  --query "AttachedPolicies[?(PolicyName=='${NAME}-policy')].PolicyArn" --output text)
  if [ -z "${POLICY_ARN}" ]; then
    info "Attaching IAM policy ${NAME}-policy with IAM role ${NAME}-role"
    aws iam attach-role-policy \
    --role-name ${NAME}-role \
    --policy-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${NAME}-policy"
  fi
}

create_group() {
  if ! aws iam get-group --group-name ${NAME} >/dev/null 2>&1; then
    aws iam create-group --group-name ${NAME}
  fi
}

put_group_policy() {
  POLICY_NAME=$(aws iam list-group-policies \
  --group-name ${NAME} \
  --query "PolicyNames[0]=='${NAME}-group-policy'")
  if ! ${POLICY_NAME}; then
    info "Attaching IAM group policy ${NAME}-group-policy with IAM group ${NAME}"
    aws iam put-group-policy \
    --group-name ${NAME} \
    --policy-name ${NAME}-group-policy \
    --policy-document "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"AssumeAppviaWorshopAdminRole\",\"Effect\":\"Allow\",\"Action\":\"sts:AssumeRole\",\"Resource\":\"arn:aws:iam::${AWS_ACCOUNT_ID}:role/${NAME}-role\"}]}"
  fi
}

validate_user() {
  if [ -z "${USER_NAME}" ]; then
    usage
  elif ! aws iam get-user --user-name ${USER_NAME} >/dev/null 2>&1; then
    echo "AWS IAM user ${USER_NAME} does not exist"
    exit 1
  fi
}

add_user_to_group() {
  GROUP_NAME=$(aws iam list-groups-for-user \
  --user-name ${USER_NAME} \
  --query "Groups[?(GroupName=='${NAME}')].GroupName" \
  --output text)
  if [ -z "${GROUP_NAME}" ]; then
    info "Adding IAM user ${USER_NAME} to IAM group ${NAME}"
    aws iam add-user-to-group \
    --group-name ${NAME} \
    --user-name ${USER_NAME}
  fi
}

validate_user
create_role
create_iam_policy
attach_role_policy
create_group
put_group_policy
add_user_to_group
