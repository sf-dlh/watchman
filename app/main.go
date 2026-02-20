package main

import (
	"context"
	"log"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

func main() {

	// getting credentials/iam role, context added to avoid hanging
	cfg, err := config.LoadDefaultConfig(context.TODO())
	// if error exists, give log of error
	if err != nil {
		log.Fatal(err)
	}

	// creating the s3 client
	client := s3.NewFromConfig(cfg)

	// for loop to not exit and force restart when main is done
	for {

		// telling the client to list all buckets using .ListBucket, the form (ListBucketsInput) is empty because we want all buckets.
		outputBuckets, err := client.ListBuckets(context.TODO(), &s3.ListBucketsInput{})
		if err != nil {
			log.Fatalf("Can't reach buckets, %s", err)
		}

		// iterating over the found buckets
		for _, bucket := range outputBuckets.Buckets {
			log.Printf("Bucket Name=%s Creation Date=%s\n Objects Associated= ", aws.ToString(bucket.Name), aws.ToTime(bucket.CreationDate))

			// to get objects assoicated with the current bucket iteration we use the client again to look for the
			// objects inside the current bucket iteration using ListObjects
			outputObjects, err := client.ListObjectsV2(context.TODO(), &s3.ListObjectsV2Input{

				// no need for aws.String wrapper because bucket.Name is already an address (type *string)
				Bucket: bucket.Name,
			})
			if err != nil {
				// if no permissions for bucket, just say which iteration and dont break the loop
				log.Printf("Error checking bucket %s: %s", aws.ToString(bucket.Name), err)
				continue
			}

			// iterating over the current bucket's objects
			for _, object := range outputObjects.Contents {

				//used aws.ToString() and aws.ToInt64 instead of *object.X to prevent segfaults
				//  (basically if the address provided doesnt exist dont crash but return empty string, can use err!=nil too)
				log.Printf("Object Name=%s Size=%d", aws.ToString(object.Key), aws.ToInt64(object.Size))
			}

		}

		// scan every 1 min
		time.Sleep(1 * time.Minute)

	}
}
