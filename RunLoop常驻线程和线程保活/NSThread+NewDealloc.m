//
//  NSThread+NewDealloc.m
//  RunLoop常驻线程和线程保活
//
//  Created by 翟旭博 on 2023/5/6.
//

#import "NSThread+NewDealloc.h"

@implementation NSThread (NewDealloc)
- (void)dealloc {
    NSLog(@"%s", __func__);
    NSLog(@"%@",self);
}
@end
