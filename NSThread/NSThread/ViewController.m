//
//  ViewController.m
//  NSThread
//
//  Created by Sniper on 15/12/13.
//  Copyright © 2015年 ShengQiang. All rights reserved.
//

#import "ViewController.h"

NSString *const kUrl = @"http://musicdata.baidu.com/data2/pic/115438533/115438533.jpg";

@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;

@property (nonatomic, strong) NSThread *thread1;
@property (nonatomic, strong) NSThread *thread2;
@property (nonatomic, strong) NSThread *thread3;

@property (nonatomic, assign) NSUInteger number;
@property (nonatomic, strong) NSLock *lock;
@end

@implementation ViewController
int i = 0;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.imageView.frame = CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height);
    self.button1.frame = CGRectMake(0, 50, self.view.frame.size.width/2, 50);
    self.button2.frame = CGRectMake(self.view.frame.size.width/2, 50, self.view.frame.size.width/2, 50);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    
    
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
    
}

/**
 *  NSThread 创建线程的几种方式
 */
- (void)button1Click:(UIButton *)sender
{
    /**
     *  相关参数说明：
     *  selector：线程执行调用的方法，selector 必须只能有一个参数，并且没有返回值
     *  target：作为 selector 消息发送的对象
     *  object：作为传输给 target 的唯一参数，可以设置为 nil
     */
    //  1、直接创建一个新线程，并执行
    [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:kUrl];
    //  2、创建一个新的后台线程，并执行
    [self performSelectorInBackground:@selector(downloadImage:) withObject:kUrl];
    //  3、在指定的线程上执行方法，默认的mode
    [self performSelector:@selector(downloadImage:) onThread:[NSThread currentThread] withObject:kUrl waitUntilDone:YES];
    //  4、返回一个初始化并设置了参数的线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadImage:) object:kUrl];
    [thread start];
}

- (void)downloadImage:(NSString *)url
{
    /**
     *  获取当前线程，判断是否为主线程
     */
    NSLog(@"downloadImage:%d", [NSThread currentThread].isMainThread);
    
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [[UIImage alloc] initWithData:data];
    /**
     *  在主线程更新UI，对于iOS 里面默认的UI操作，必须使用主线程
     */
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
}

- (void)updateUI:(UIImage *)image
{
    /**
     *  获取当前线程，判断是否为主线程
     */
    NSLog(@"updateUI:%d", [NSThread currentThread].isMainThread);
    self.imageView.image = image;
}
/************************************华丽的分割线**************************************/
/**
 *  线程同步、顺序执行，锁的相关知识
 *  锁有 NSLock、NSCodition、NSRecursiveLock、NSConditionLock几种
 */
- (void)button2Click:(UIButton *)sender
{
    self.lock = [[NSLock alloc] init];

    self.thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    self.thread1.name = @"thread1";
    [self.thread1 start];

    
    
    self.thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    self.thread2.name = @"thread2";
    [self.thread2 start];
    
    
    self.thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    self.thread3.name = @"thread3";
    [self.thread3 start];
    
    
}


- (void)run
{
    while (i < 1000) {
        /**
         *  使用锁来顺序执行线程
         */
        [self.lock lock];
        NSLog(@"%@：%ld\n", [NSThread currentThread].name, self.number++);
        i++;
        [self.lock unlock];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
