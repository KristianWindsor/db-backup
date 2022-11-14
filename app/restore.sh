#!/bin/bash

# get file name
echo "Possible matches:"
aws s3 ls s3://$S3_BUCKET_NAME | grep $FILE_NAME
export FILE_NAME=$(aws s3 ls s3://$S3_BUCKET_NAME | grep $FILE_NAME | sort | tail -n 1 | awk '{print $4}')
echo "Using file: $FILE_NAME"

# download file
aws s3 cp s3://$S3_BUCKET_NAME/$FILE_NAME ./

# restore db
if [[ $DB_ENGINE == *"mysql"* ]]; then
    export MYSQL_PWD="$DB_PASSWORD"
    set -x
    mysql -h $DB_HOST -P $DB_PORT -u $DB_USERNAME $DB_NAME < $FILE_NAME
elif [[ $DB_ENGINE == *"postgres"* ]]; then
    export PGPASSWORD="$DB_PASSWORD"
    set -x
    pg_restore --clean -h $DB_HOST -p $DB_PORT -U $DB_USERNAME -d $DB_NAME $FILE_NAME
fi

# done
set +x
echo -e "${GREEN}All done! ${NO_COLOR}"