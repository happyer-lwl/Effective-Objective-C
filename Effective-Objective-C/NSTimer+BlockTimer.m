//
//  NSTimer+BlockTimer.m
//  Effective-Objective-C
//
//  Created by WyzcWin on 16/12/5.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "NSTimer+BlockTimer.h"

@implementation NSTimer (BlockTimer)

+ (NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(eoc_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)eoc_blockInvoke:(NSTimer *)timer{
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
