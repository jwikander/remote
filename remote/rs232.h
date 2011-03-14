//
//  rs232.h
//  remote
//
//  Created by Johan Wikander on 3/12/11.
//  Copyright 2011 JW. All rights reserved.
//

#import <stdio.h>

#import <Foundation/Foundation.h>


@interface rs232 : NSObject {
    int fileDescriptor;
}
- (void)openPort: (NSString*) bsdPath;
- (void)closePort;
    


@end
