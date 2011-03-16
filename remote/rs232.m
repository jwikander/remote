//
//  rs232.m
//  remote
//
//  Created by JW on 3/12/11.
//  Copyright 2011 JW. All rights reserved.
//

#import "rs232.h"


@implementation rs232

- (id)init
{
    if ((self = [super init])) {
        fileDescriptor = -1;
    }
    
    return self;
}

- (void)openPort: (NSString*) bsdPath
{
    // Open the port read/write, no terminal, non blocking 
    
    fileDescriptor = open([bsdPath UTF8String], O_RDWR | O_NOCTTY | O_NONBLOCK);
    if (fileDescriptor == -1) {
        printf("Error opening port %s - %s(%d).\n", [bsdPath UTF8String],
               strerror(errno), errno);
        exit(1);
    }
    
    
    // Prevent additional opens to the port
    
    if (ioctl(fileDescriptor, TIOCEXCL) == -1) {
        printf("Error setting TIOCEXCL on %s - %s(%d).\n", [bsdPath UTF8String],
               strerror(errno), errno);
        exit(1);
    }
    
    
    // Now that the port is open, clear O_NONBLOCK so that I/O will block
    
    if (fcntl(fileDescriptor, F_SETFL, 0) == -1) {
        printf("Error clearing O_NONBLOCKING on %s - %s(%d).\n",
               [bsdPath UTF8String], strerror(errno), errno);
        exit(1);
    }
    
    
    // Store the original port options so they can be restored later
    
    if (tcgetattr(fileDescriptor, &optionsOriginal) == -1) {
        printf("Error getting attributes on %s - %s(%d).\n",
               [bsdPath UTF8String], strerror(errno), errno);
        exit(1);
    }
}


- (void)closePort
{
    
}

@end
