#!/bin/bash

# backup db
if [[ $DB_ENGINE == *"mysql"* ]]; then
    FILE_NAME="$FILE_NAME-$(date '+%Y-%m-%d').sql"
    export MYSQL_PWD="$DB_PASSWORD"
    set -x
    mysqldump --column-statistics=0 --verbose -h $DB_HOST -P $DB_PORT -u $DB_USERNAME $DB_NAME > $FILE_NAME
elif [[ $DB_ENGINE == *"postgres"* ]]; then
    FILE_NAME="$FILE_NAME-$(date '+%Y-%m-%d').dump"
    export PGPASSWORD="$DB_PASSWORD"
    set -x
    pg_dump --verbose -h $DB_HOST -p $DB_PORT -Fc -U $DB_USERNAME $DB_NAME > $FILE_NAME
fi

# upload to s3
aws s3 cp $FILE_NAME s3://$S3_BUCKET_NAME/

# done
set +x
FILE_SIZE=$(ls -lh | grep $FILE_NAME | awk -F " " {'print $5'})
echo -e "${GREEN}All done! ${NO_COLOR}"
echo -e "${GREEN}    File size: ${FILE_SIZE}${NO_COLOR}"
echo -e "${GREEN}    File location: s3://${S3_BUCKET_NAME}/${FILE_NAME}${NO_COLOR}"