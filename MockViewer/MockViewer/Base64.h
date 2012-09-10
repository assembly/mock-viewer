//
//  Base64.h
//  MockViewer
//
//  Created by Foy Savas on 9/10/12.
//  Copyright (c) 2012 Assembly Development Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject

+(NSString *)encode:(NSData *)plainText;

@end
