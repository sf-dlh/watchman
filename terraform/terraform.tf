terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "~> 5.92"			
		}	
	}

	backend "s3" {
		bucket = "sf-watchman-state"
		key = "watchman/terraform.tfstate"
		region = "us-east-1"
		// for native state locking, thought about using dynamodb but HC's documentation says its being deprecated
		use_lockfile = true
	}




	required_version = ">= 1.2"
}
