package main

import (
	"context"
	"log"

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

	// telling the client to look for a specific bucket using .ListObjectsV2Input, basically our input
	// mapping the result to output from which we'll list our contents
	output, err := client.ListObjectsV2(context.TODO(), &s3.ListObjectsV2Input{
		// aws.String wrapper because it expects an address (*string, not a string)
		// also value hardcoded for now, will change later
		Bucket: aws.String("my-bucket"),
	})
	if err != nil {
		log.Fatal(err)
	}

	// iterating over the results and printing them
	log.Println("first page results")
	for _, object := range output.Contents {

		//used aws.ToString() and aws.ToInt64 instead of *object.X to prevent segfaults
		//  (basically if the address provided doesnt exist dont crash but return empty string, can use err!=nil too)
		log.Printf("key=%s size=%d", aws.ToString(object.Key), aws.ToInt64(object.Size))
	}

}
