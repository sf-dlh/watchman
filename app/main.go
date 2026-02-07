package main

import (
"fmt"
"time"
)

func main() {
	for  {
	fmt.Printf("[%v] Watchman : Checking S3 Status...\n", time.Now().Format("01-02-2006 15:04"))
	time.Sleep(5 * time.Second)
	}

}