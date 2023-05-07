//
//  SecondViewController.m
//  RunLoop常驻线程和线程保活
//
//  Created by 翟旭博 on 2023/5/6.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (nonatomic, strong) NSThread *aThread;
@property (nonatomic, assign) BOOL stopped;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加一个停止RunLoop的按钮
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:stopButton];
    stopButton.frame = CGRectMake(180, 180, 100, 50);
    stopButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [stopButton setTitle:@"stop" forState:UIControlStateNormal];
    stopButton.tintColor = [UIColor blueColor];
    [stopButton addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    
    // 用于返回的按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:backButton];
    backButton.frame = CGRectMake(180, 380, 100, 50);
    backButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [backButton setTitle:@"back" forState:UIControlStateNormal];
    backButton.tintColor = [UIColor orangeColor];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    
    self.stopped = NO;
    __weak typeof(self) weakSelf = self;
    self.aThread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"go");
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        while (!weakSelf.stopped) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSLog(@"ok");
    }];
    [self.aThread start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(doSomething) onThread:self.aThread withObject:nil waitUntilDone:NO];
}

// 子线程需要执行的任务
- (void)doSomething {
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
}

- (void)stop {
    // 在子线程调用stop
    if (self.aThread) {
        // 在子线程调用stop
        [self performSelector:@selector(stopThread) onThread:self.aThread withObject:nil waitUntilDone:YES];
    }
}

// 用于停止子线程的RunLoop
- (void)stopThread {
    // 设置标记为NO
    self.stopped = YES;
    
    // 停止RunLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    
    self.aThread = nil;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}


- (void)back {
    [self stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
