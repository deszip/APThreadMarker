//
//  APThreadMarker.m
//  AP-Gloss
//
//  Created by Deszip on 20.11.13.
//  Copyright (c) 2013 alterplay. All rights reserved.
//

#import "APThreadMarker.h"

#include <sys/time.h>

static APThreadMarker *sharedMarker = nil;

@interface APThreadMarker ()

+ (instancetype)sharedMarker;

@end

@implementation APThreadMarker

+ (instancetype)sharedMarker
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMarker = [[APThreadMarker alloc] init];
        
        sharedMarker.threadsMarkers = [NSMutableArray array];
        
        [[NSThread mainThread] setName:kAPThreadMarkMain];
        [sharedMarker.threadsMarkers addObject:kAPThreadMarkMain];
        NSLog(@"Main thread marked");
    });
    
    return sharedMarker;
}

+ (void)markCurrentThreadWithName:(NSString *)threadName
{
    [APThreadMarker sharedMarker];
    if ([[NSThread currentThread] isMainThread]) {
        NSLog(@"Trying to mark main thread! Probably something is running on main instead of background");
        
        return;
    }
    
    NSString *currentName = [[NSThread currentThread] name];
    if (currentName.length > 0) {
        /* Skip if we have already marked that thread */
        NSLog(@"Trying to mark thread %@ as %@", currentName, threadName);
    } else {
        if (threadName.length == 0) {
            threadName = kAPThreadMarkDefault;
        }
        
        /* Get thread ID based on microtime */
        struct timeval time_value;
        gettimeofday(&time_value, NULL);
        NSString *threadID = [NSString stringWithFormat:@"%li%i", time_value.tv_sec, time_value.tv_usec];
        
        threadName = [threadID stringByAppendingFormat:@".%@", threadName];
        [[NSThread currentThread] setName:threadName];
        [sharedMarker.threadsMarkers addObject:threadName];
    }
    
    //NSLog(@"Marked thread: %@", threadName);
}

+ (void)markCurrentThread
{
    [APThreadMarker markCurrentThreadWithName:@""];
}

@end
