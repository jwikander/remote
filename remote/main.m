//
//  main.m
//  remote
//
//  Created by Johan Wikander on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "rs232.h"

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
	printf("Start\n");
	rs232* Port;
	Port = [[rs232 alloc] init];
	[Port openPort:@"Hej"];
	[Port issueCommand];
	
    return NSApplicationMain(argc, (const char **)argv);
	
	[Port closePort];
	[Port release];
}
