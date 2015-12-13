//
//  ViewController.m
//  NSOperation
//
//  Created by Sniper on 15/12/13.
//  Copyright © 2015年 ShengQiang. All rights reserved.
//

#import "ViewController.h"
#import "MyOperationDownloader.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;

@end

@implementation ViewController
/*
 http://blog.cnbluebox.com/blog/2014/07/01/cocoashen-ru-xue-xi-nsoperationqueuehe-nsoperationyuan-li-he-shi-yong/
 http://www.hrchen.com/2013/06/multi-threading-programming-of-ios-part-2/
 */

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.button1.frame = CGRectMake(0, 50, self.view.frame.size.width/4, 50);
    self.button2.frame = CGRectMake(self.view.frame.size.width/4, 50, self.view.frame.size.width/4, 50);
    self.button3.frame = CGRectMake(self.view.frame.size.width/2, 50, self.view.frame.size.width/4, 50);
    self.button4.frame = CGRectMake(self.view.frame.size.width/4*3, 50, self.view.frame.size.width/4, 50);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button1 setTitle:@"示例一" forState:UIControlStateNormal];
    [self.button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button1 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button1];
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button2 setTitle:@"示例二" forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button2 addTarget:self action:@selector(button2Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button2];
    
    self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button3 setTitle:@"示例三" forState:UIControlStateNormal];
    [self.button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button3 addTarget:self action:@selector(button3Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button3];
    
    self.button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button4 setTitle:@"示例四" forState:UIControlStateNormal];
    [self.button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button4 addTarget:self action:@selector(button4Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button4];

}

/**
 *  NSInvocationOperation
 */
- (void)button1Click:(UIButton *)sender
{
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test:) object:@"NSInvocationOperation"];
    [operation start];
}

/**
 *  NSBlockOperation
 */
- (void)button2Click:(UIButton *)sender
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"current thread1 : %@", [NSThread currentThread]);
    }];
    [operation addExecutionBlock:^{
        NSLog(@"current thread2 : %@", [NSThread currentThread]);
    }];
    [operation addExecutionBlock:^{
        NSLog(@"current thread3 : %@", [NSThread currentThread]);
    }];
    [operation start];
}

/**
 *  NSOperationQueue
 *
 */
- (void)button3Click:(UIButton *)sender
{
    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test1:) object:@"NSInvocationOperation1"];
    NSInvocationOperation *operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test2:) object:@"NSInvocationOperation2"];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"NSBlockOperation : %d : %@", i, [NSThread currentThread]);
        }
    }];
    
    
    /**
     *  不设置依赖，线程为异步执行的；设置依赖，线程串行执行
     */
//    // 线程二依赖于线程一的执行，线程一执行完成，线程二才会执行
//    [operation2 addDependency:operation1];
//    // 线程三依赖于线程二的执行，线程二执行完成，线程三才会执行
//    [operation3 addDependency:operation2];
    
    
    // 线程三最后执行完成的回调
    operation3.completionBlock = ^
    {
        NSLog(@"线程执行完毕");
    };
    
    /**
     *  NSOperationQueue 有两种队列：主队列和自定义队列(用户队列)，自定义队列。主队列运行在主线程之上，自定义队列在后台执行。主队列默认是串行队列
     */
    // 自定义队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 主队列，默认是串行队列
//    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    
    /**
     *  并发数设置为 1 默认为串行队列，主队列默认是串行队列
     */
    queue.maxConcurrentOperationCount = 1;
    
    
    /**
     *  将线程添加对队列中
     */
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    

}

/**
 *  自定义 NSOperationQueue 子类
 */
- (void)button4Click:(UIButton *)sender
{
    static NSString *URLString = @"http://farm7.staticflickr.com/6191/6075294191_4c8ca20409.jpg";
    [MyOperationDownloader downloadWithUrl:[NSURL URLWithString:URLString] success:^(id responseData) {
        NSLog(@"%@", responseData);
    } failure:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

- (void)test:(NSString *)name
{
    NSLog(@"--test--%@--", name);
}


- (void)test1:(NSString *)name {
    for (int i = 0; i < 5; i++) {
        NSLog(@"%@ : %d : %@", name, i, [NSThread currentThread]);
    }
}

- (void)test2:(NSString *)name  {
    for (int i = 0; i < 5; i++) {
        NSLog(@"%@ : %d : %@", name, i, [NSThread currentThread]);
    }
}




@end
