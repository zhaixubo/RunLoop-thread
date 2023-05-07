//
//  NSTread+NewDealloc.m
//  RunLoop常驻线程和线程保活
//
//  Created by 翟旭博 on 2023/5/6.
//

#import "NSTread+NewDealloc.h"

@implementation NSTread (NewDealloc)
- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
