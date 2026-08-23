#!/bin/bash

ZONE_ID="Z0483628AIFCHMGXCTIX"
DOMAIN_NAME="kanakam.online"

INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")

echo "Starting cleanup..."

for instance in "${INSTANCES[@]}"
do

    echo "Deleting Route53 record for $instance..."

    # Get instance private/public IP
    INSTANCE_ID=$(aws ec2 describe-instances \
        --filters "Name=tag:Name,Values=$instance" \
        --query 'Reservations[].Instances[].InstanceId' \
        --output text)

    if [ -z "$INSTANCE_ID" ]
    then
        echo "$instance instance not found"
        continue
    fi

    if [ "$instance" == "frontend" ]
    then
        IP=$(aws ec2 describe-instances \
            --instance-ids "$INSTANCE_ID" \
            --query 'Reservations[0].Instances[0].PublicIpAddress' \
            --output text)

        RECORD_NAME="$DOMAIN_NAME"

    else
        IP=$(aws ec2 describe-instances \
            --instance-ids "$INSTANCE_ID" \
            --query 'Reservations[0].Instances[0].PrivateIpAddress' \
            --output text)

        RECORD_NAME="$instance.$DOMAIN_NAME"
    fi

    # Delete Route53 record
    aws route53 change-resource-record-sets \
        --hosted-zone-id "$ZONE_ID" \
        --change-batch "{
            \"Changes\": [{
                \"Action\": \"DELETE\",
                \"ResourceRecordSet\": {
                    \"Name\": \"$RECORD_NAME\",
                    \"Type\": \"A\",
                    \"TTL\": 300,
                    \"ResourceRecords\": [{
                        \"Value\": \"$IP\"
                    }]
                }
            }]
        }"

    echo "Route53 record deleted: $RECORD_NAME"

    # Terminate EC2 instance
    echo "Terminating $instance instance..."

    aws ec2 terminate-instances \
        --instance-ids "$INSTANCE_ID"

    echo "$instance terminated"

done

echo "Cleanup completed."