//
//  FirstViewController.m
//  RunLoop常驻线程和线程保活
//
//  Created by 翟旭博 on 2023/5/6.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
@interface FirstViewController ()
@property (nonatomic, strong) NSThread *thread;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *goButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    goButton.frame = CGRectMake(50, 50, 50, 50);
    goButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:goButton];
    [goButton addTarget:self action:@selector(pressGo) forControlEvents:UIControlEventTouchUpInside];

    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run1) object:nil];
    [self.thread start];

}

- (void)run1 {
    NSLog(@"----run1-----");

    /*如果不加这句，会发现runloop创建出来就挂了，因为runloop如果没有CFRunLoopSourceRef事件源输入或者定时器，就会立马消亡。
          下面的方法给runloop添加一个NSport，就是添加一个事件源，也可以添加一个定时器，或者observer，让runloop不会挂掉*/

    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    // 方法1 ,2，3实现的效果相同，让runloop无限期运行下去
    // 方法2
//    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    // 方法3
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
        
    [[NSRunLoop currentRunLoop] run];
        // 测试是否开启了RunLoop，如果开启RunLoop，则来不了这里，因为RunLoop开启了循环。
        NSLog(@"未开启RunLoop");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 利用performSelector，在self.thread的线程中调用run2方法执行任务
    [self performSelector:@selector(run2) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)run2 {
    NSLog(@"----run2------");
}

- (void)pressGo {
    SecondViewController *secondViewController = [[SecondViewController alloc] init];
    secondViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:secondViewController animated:YES completion:nil];
}

@end
