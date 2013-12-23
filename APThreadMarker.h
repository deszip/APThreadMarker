//
//  APThreadMarker.h
//  AP-Gloss
//
//  Created by Deszip on 20.11.13.
//  Copyright (c) 2013 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAPThreadMarkMain       @"Main thread"
#define kAPThreadMarkDefault    @"Thread"

@interface APThreadMarker : NSObject {
    NSMutableArray *_threadsMarkers;
}

@property (strong, nonatomic) NSMutableArray *threadsMarkers;

+ (void)markCurrentThreadWithName:(NSString *)threadName;
+ (void)markCurrentThread;

@end
