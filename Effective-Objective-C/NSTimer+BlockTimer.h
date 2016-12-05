//
//  NSTimer+BlockTimer.h
//  Effective-Objective-C
//
//  Created by WyzcWin on 16/12/5.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (BlockTimer)

+ (NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void (^)())block
                                        repeats:(BOOL)repeats;


@end
