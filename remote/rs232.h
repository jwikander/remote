//
//  rs232.h
//  remote
//
//  Created by JW on 3/12/11.
//  Copyright 2011 JW. All rights reserved.
//

#import <sys/ioctl.h>
#import <stdio.h>
#import <termios.h>

#import <Foundation/Foundation.h>


@interface rs232 : NSObject {
    int fileDescriptor;
	NSString* bsdPath;
    struct termios optionsOriginal;
    struct termios optionsNew;
}

- (id)init;
- (void)openPort: (NSString*) path;
- (void)issueCommand;
- (void)closePort;
    


@end
