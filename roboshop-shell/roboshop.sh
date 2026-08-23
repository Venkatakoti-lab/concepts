#!/bin/bash

AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-06fd37fbfc4d98c41"

ZONE_ID="Z0483628AIFCHMGXCTIX"
DOMAIN_NAME="kanakam.online"

INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")

for instance in "${INSTANCES[@]}"
do

    echo "Creating $instance instance..."

    INSTANCE_ID=$(aws ec2 run-instances \
        --image-id "$AMI_ID" \
        --instance-type t3.micro \
        --security-group-ids "$SG_ID" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
        --query 'Instances[0].InstanceId' \
        --output text)

    echo "$instance instance ID: $INSTANCE_ID"

    # Wait until instance is running
    aws ec2 wait instance-running \
        --instance-ids "$INSTANCE_ID"

    if [ "$instance" == "frontend" ]
    then

        # Get Public IP
        IP=$(aws ec2 describe-instances \
            --instance-ids "$INSTANCE_ID" \
            --query 'Reservations[0].Instances[0].PublicIpAddress' \
            --output text)

        echo "Frontend Public IP: $IP"

        # Create Route53 record
        aws route53 change-resource-record-sets \
            --hosted-zone-id "$ZONE_ID" \
            --change-batch "{
                \"Changes\": [{
                    \"Action\": \"UPSERT\",
                    \"ResourceRecordSet\": {
                        \"Name\": \"$DOMAIN_NAME\",
                        \"Type\": \"A\",
                        \"TTL\": 300,
                        \"ResourceRecords\": [{
                            \"Value\": \"$IP\"
                        }]
                    }
                }]
            }"

        echo "Route53 record created: $DOMAIN_NAME -> $IP"

    else

        # Get Private IP
        IP=$(aws ec2 describe-instances \
            --instance-ids "$INSTANCE_ID" \
            --query 'Reservations[0].Instances[0].PrivateIpAddress' \
            --output text)

        echo "$instance Private IP: $IP"

        # Create Route53 private/internal record
        aws route53 change-resource-record-sets \
            --hosted-zone-id "$ZONE_ID" \
            --change-batch "{
                \"Changes\": [{
                    \"Action\": \"UPSERT\",
                    \"ResourceRecordSet\": {
                        \"Name\": \"$instance.$DOMAIN_NAME\",
                        \"Type\": \"A\",
                        \"TTL\": 300,
                        \"ResourceRecords\": [{
                            \"Value\": \"$IP\"
                        }]
                    }
                }]
            }"

        echo "Route53 record created: $instance.$DOMAIN_NAME -> $IP"

    fi

done