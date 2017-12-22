//
//  ViewController.m
//  线程与锁
//
//  Created by ShengQiangLiu on 16/12/23.
//  Copyright © 2016年 mob. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
#import "BigDog.h"
#import "libkern/OSAtomic.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
        使用 pthread_mutex_t 实现锁
     */
//    // 创建锁对象
//    __block pthread_mutex_t mutex;
//    pthread_mutex_init(&mutex, NULL);
//    
//    // 线程 A
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        pthread_mutex_lock(&mutex);
//        
//        NSLog(@"线程 A1 。");
//        [NSThread sleepForTimeInterval:3];
//        
//        pthread_mutex_unlock(&mutex);
//    });
//    
//    
//    // 线程 B
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        pthread_mutex_lock(&mutex);
//        
//        NSLog(@"线程 B1 。");
//        [NSThread sleepForTimeInterval:3];
//        
//        pthread_mutex_unlock(&mutex);
//    });
    
    
    
    /**
        使用GCD实现“锁”（信号量）
     */
//    // 创建并设置信号量
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
//    
//    // 线程 A
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        
//        NSLog(@"线程 A2 。");
//        [NSThread sleepForTimeInterval:3];
//        
//        dispatch_semaphore_signal(semaphore);
//    });
//    
//    
//    // 线程 B
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        
//        NSLog(@"线程 B2 。");
//        [NSThread sleepForTimeInterval:3];
//        
//        dispatch_semaphore_signal(semaphore);
//    });
    
    // 创建并设置信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    // 线程 A
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSLog(@"线程 A2 。");
        [NSThread sleepForTimeInterval:3];
        
        dispatch_semaphore_signal(semaphore);
    });
    
    
    // 线程 B
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSLog(@"线程 B2 。");
        [NSThread sleepForTimeInterval:3];
        
        dispatch_semaphore_signal(semaphore);
    });
    
    /**
     使用POSIX（条件锁）创建锁
     */
//    // 创建互斥锁
//    __block pthread_mutex_t  mutex;
//    pthread_mutex_init(&mutex, NULL);
//    
//    // 创建条件锁
//    __block pthread_cond_t cond;
//    pthread_cond_init(&cond, NULL);
//    
//    // 线程 A
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        pthread_mutex_lock(&mutex);
//        pthread_cond_wait(&cond, &mutex);
//        
//        NSLog(@"线程 A3 。");
//
//        
//        pthread_mutex_unlock(&mutex);
//    });
//
//
//    // 线程 B
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        pthread_mutex_lock(&mutex);
//        
//        NSLog(@"线程 B3 。");
//        [NSThread sleepForTimeInterval:3];
//
//        pthread_cond_signal(&cond);
//        pthread_mutex_unlock(&mutex);
//    });
    /**
     效果：程序会首先调用线程B，在5秒后再调用线程A。因为在线程A中创建了等待条件锁，线程B有激活锁，只有当线程B执行完后会激活线程A。
     
     pthread_cond_wait方法为等待条件锁。
     
     pthread_cond_signal方法为激动一个相同条件的条件锁。
     */


    /**
     使用 OSSpinLock 创建锁
     */
//    __block OSSpinLock spinlock = OS_SPINLOCK_INIT;
//    // 线程 A
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        OSSpinLockLock(&spinlock);
//        
//        NSLog(@"线程 A4 。");
//        [NSThread sleepForTimeInterval:3];
//
//        OSSpinLockUnlock(&spinlock);
//    });
//
//
//    // 线程 B
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        OSSpinLockLock(&spinlock);
//        
//        NSLog(@"线程 B4 。");
//        [NSThread sleepForTimeInterval:3];
//
//        OSSpinLockUnlock(&spinlock);
//    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
