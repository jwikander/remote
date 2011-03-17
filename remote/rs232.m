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

- (void)openPort: (NSString*) path
{
	[bsdPath initWithString:path];
	
	// XXX debug
	bsdPath = @"/dev/tty.usbserial-FTF3DHJK";
	
    // Open the port read/write, no terminal, non blocking 
    
    fileDescriptor = open([bsdPath UTF8String], O_RDWR | O_NOCTTY | O_NONBLOCK);
    if (fileDescriptor == -1) {
        printf("Error opening port %s - %s(%d).\n", [bsdPath UTF8String],
               strerror(errno), errno);
        exit(1);
    }
	
	printf("Port open\n");
    
    
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
    
    
    // Save original options to new options as starting point
    
    optionsNew = optionsOriginal;
    
    
    // XXX DEBUG
    
    printf("Original input rate: %d", (int) cfgetispeed(&optionsNew));
    printf("\nOriginal input rate: %d", (int) cfgetispeed(&optionsNew));
    
    
    // Setup the port according to Pioneer manual
    
    cfsetspeed(&optionsNew, B9600);
    optionsNew.c_cflag |= (CS8 |        // 8 data bits
                           !PARENB |    // No parity
                           !CSTOPB);    // 1 stop bit
    
	
    // Enable the new options
    
    if (tcsetattr(fileDescriptor, TCSANOW, &optionsNew) == -1) {
        printf("Error setting attributes on %s - %s(%d).\n",
               [bsdPath UTF8String], strerror(errno), errno);
        exit(1);
    }
                           
}


- (void)closePort
{
	// Reset the port attributes to original values
	
    if (tcsetattr(fileDescriptor, TCSANOW, &optionsOriginal) == -1)
    {
        printf("Error resetting attributes on %s - %s(%d).\n",
			   [bsdPath UTF8String], strerror(errno), errno);
    }
	
    close(fileDescriptor);

    
}

- (void)issueCommand
{
	printf("\n\nWRITING!\n\n");
	char* command = "VU\r\n";
	write(fileDescriptor, command, strlen(command));
}

@end
