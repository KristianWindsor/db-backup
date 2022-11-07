#!/bin/bash

# create backup
if [[ $DB_ENGINE == *"mysql"* ]]; then
    export MYSQL_PWD="$DB_PASSWORD"
    set -x
    mysqldump -h $DB_HOST -P $DB_PORT -u $DB_USERNAME $DB_NAME > $FILE_NAME.sql
elif [[ $DB_ENGINE == *"postgres"* ]]; then
    export PGPASSWORD="$DB_PASSWORD"
    set -x
    pg_dump -h $DB_HOST -p $DB_PORT -Fc -o -U $DB_USERNAME $DB_NAME > $FILE_NAME.dump
fi

# upload to s3
aws s3 cp $FILE_NAME* s3://$S3_BUCKET_NAME/

# keep alive
while true; do sleep 10000; done