#!/bin/bash

# ------------------------- #
# Error & Warning Functions #
# ------------------------- #
# color codes
RED='\033[0;31m'
YELLOW='\033[33m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'
# error: undefined
param_undefined_error() {
    VAR_NAME=$1
    echo -e "${RED}Error: \$${VAR_NAME} is undefined${NO_COLOR}"
    if [[ $DEBUG_MODE != "true" ]]; then
        exit 1
    fi
}
# warning: undefined
param_undefined_warning() {
    VAR_NAME=$1
    WARN_MSG=$2
    echo -e "${YELLOW}Warning: \$${VAR_NAME} is undefined${NO_COLOR}"
    if [ -n "$WARN_MSG" ]; then
        echo -e "${YELLOW}    ${WARN_MSG}${NO_COLOR}"
    fi
}
# error: invalid
param_invalid_error() {
    VAR_NAME=$1
    VAR_VALUE=$2
    ERR_MSG=$3
    echo -e "${RED}Error: \$${VAR_NAME} value is invalid: ${VAR_VALUE}${NO_COLOR}"
    if [ -n "$ERR_MSG" ]; then
        echo -e "${RED}    ${ERR_MSG}${NO_COLOR}"
    fi
    if [[ $DEBUG_MODE != "true" ]]; then
        exit 1
    fi
}

# ---------------- #
# Check Parameters #
# ---------------- #
# debug mode
if [[ $DEBUG_MODE == "true" ]]; then
    echo "Debug mode is on. Parameter errors will be ignored and the container will be kept alive."
fi
# action
if [ -z "$ACTION" ]; then
    WARN_MSG="Using default action: backup"
    param_undefined_warning "ACTION" "$WARN_MSG"
    export ACTION="backup"
else
    export ACTION=$(echo "$ACTION" | tr '[:upper:]' '[:lower:]')
    if [[ $ACTION != "backup" ]] && [[ $ACTION != "restore" ]]; then
        ERR_MSG='$ACTION should be "backup" or "restore"'
        param_invalid_error "ACTION" "$ACTION" "$ERR_MSG"
    fi
fi
# file name
if [ -z "$FILE_NAME" ]; then
    if [ -z "$DB_NAME" ]; then
        param_undefined_error "FILE_NAME"
    else
        WARN_MSG="Using \$DB_NAME value for \$FILE_NAME: $DB_NAME"
        param_undefined_warning "FILE_NAME" "$WARN_MSG"
        export FILE_NAME=$DB_NAME
    fi
fi
# db engine
if [ -z "$DB_ENGINE" ]; then
    param_undefined_error "DB_ENGINE"
else
    export DB_ENGINE=$(echo "$DB_ENGINE" | tr '[:upper:]' '[:lower:]')
    if [[ $DB_ENGINE != *"mysql"* ]] && [[ $DB_ENGINE != *"postgres"* ]]; then
        ERR_MSG='$DB_ENGINE should be "mysql" or "postgresql"'
        param_invalid_error "DB_ENGINE" "$DB_ENGINE" "$ERR_MSG"
    fi
fi
# db host
if [ -z "$DB_HOST" ]; then
    param_undefined_error "DB_HOST"
fi
# db port
if [ -z "$DB_PORT" ]; then
    if [[ $DB_ENGINE == *"mysql"* ]]; then
        WARN_MSG="Using MySQL default port for \$DB_PORT: 3306"
        param_undefined_warning "DB_PORT" "$WARN_MSG"
        export DB_PORT=3306
    elif [[ $DB_ENGINE == *"postgres"* ]]; then
        WARN_MSG="Using PostgreSQL default port for \$DB_PORT: 5432"
        param_undefined_warning "DB_PORT" "$WARN_MSG"
        export DB_PORT=5432
    fi
fi
# db username
if [ -z "$DB_USERNAME" ]; then
    param_undefined_error "DB_USERNAME"
fi
# db password
if [ -z "$DB_PASSWORD" ]; then
    param_undefined_warning "DB_PASSWORD"
fi
# db name
if [ -z "$DB_NAME" ]; then
    if [[ $DB_ENGINE == *"mysql"* ]]; then
        param_undefined_error "DB_NAME"
    elif [[ $DB_ENGINE == *"postgres"* ]]; then
        WARN_MSG="Using \$DB_USERNAME value for \$DB_NAME: $DB_NAME"
        param_undefined_warning "DB_NAME" "$WARN_MSG"
        export DB_NAME=$DB_USERNAME
    fi
fi
# aws credentials
if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    param_undefined_warning "AWS_ACCESS_KEY_ID"
fi
if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    param_undefined_warning "AWS_SECRET_ACCESS_KEY"
fi
# aws region
if [ -z "$AWS_DEFAULT_REGION" ]; then
    param_undefined_warning "AWS_DEFAULT_REGION"
fi
# s3 bucket
if [ -z "$S3_BUCKET_NAME" ]; then
    param_undefined_warning "S3_BUCKET_NAME"
fi