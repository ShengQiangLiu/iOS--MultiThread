//
//  ViewController.m
//  GCD
//
//  Created by Sniper on 15/12/12.
//  Copyright © 2015年 ShengQiang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)dispatchQueueBtnClick:(UIButton *)sender {
    /*
     Dispatch Queue分为 Serial Dispatch Queue 和 Concurrent Dispatch Queue两种。
     获取dispatch queue的两种方式：
     1、创建一个dispatch queue，使用dispatch_queue_create函数
     2、获取系统的提供的dispatch queue，Main Dispatch Queue 和 Global Dispatch Queue 这两种
     */
    
    /*
     Global Dispatch Queue 分为4个执行优先级：
     高优先级（High Priority）
     默认优先级（Default Priority）
     低优先级（Low Priority）
     后台优先级（Background Priority）
     */
    
    // 各种Dispatch Queue 的获取方法
    /*
     Main Dispatch Queue 的获取方法
     */
    dispatch_queue_t mainDispatchQueue = dispatch_get_main_queue();
    
    /*
     Global Dispatch Queue 高优先级的获取方法
     */
    dispatch_queue_t globalDispatchQueueHigh = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    /*
     Global Dispatch Queue 默认优先级的获取方法
     */
    dispatch_queue_t globalDispatchQueueDefault = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    /*
     Global Dispatch Queue 低优先级的获取方法
     */
    dispatch_queue_t globalDispatchQueueLow = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    
    /*
     Global Dispatch Queue 后台优先级的获取方法
     */
    dispatch_queue_t globalDispatchQueueBackground = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    /*
     在默认优先级的 Global Dispatch Queue 中执行 block
     */
    dispatch_async(globalDispatchQueueDefault, ^{
        // 并行执行的处理
        
        // 在主线程中执行 block
       dispatch_async(mainDispatchQueue, ^{
           
       });
    });
    
}


- (IBAction)dispatchQueueCreateBtnClick:(UIButton *)sender {
    /*
     dispatch queue 推荐使用应用程序ID这种逆序全程域名（FQDN，fully qualified domain name）
     dispatch_queue_create 第二个参数为NULL，表示为serial dispatch queue
     dispatch_queue_create 生成的dispatch queue 的优先级都是默认的优先级
     */

    dispatch_queue_t myConcurrentDispatchQueue = dispatch_queue_create("com.example.gcd", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(myConcurrentDispatchQueue, ^{
        NSLog(@"block on myConcurrentDispatchQueue");
    });



}

- (IBAction)dispatchSettargetQueueBtnClick:(UIButton *)sender {
    
    dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("com.example.gcd", NULL);
    dispatch_queue_t globalDispatchQueueBackground = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    // 第一个参数为需要变更优先级的dispatch queue，第二个参数为设置第一个参数要执行在相同的优先级
    dispatch_set_target_queue(mySerialDispatchQueue, globalDispatchQueueBackground);
    
    
}

/*
 NSDate 类对象生成 dispatch_time_t
 */

dispatch_time_t getDispatchTimeByDate(NSDate *date)
{
    NSTimeInterval interval;
    double second, subsecond;
    struct timespec time;
    dispatch_time_t milestone;
    
    interval = [date timeIntervalSince1970];
    subsecond = modff(interval, &second);
    time.tv_sec = second;
    time.tv_nsec = subsecond * NSEC_PER_SEC;
    milestone = dispatch_walltime(&time, 0);
    
    return milestone;
}

- (IBAction)dispatchAfterBtnClick:(UIButton *)sender {
    // ull 是 c 语言的数值字面量
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3ull * NSEC_PER_SEC);
    // dispatch_after 函数并不是在指定时间后执行处理，而只是在指定时间追加处理到 dispatch queue
    dispatch_after(time, dispatch_get_main_queue(), ^{
        NSLog(@"waited at least three seconds.");
    });
}


- (IBAction)dispatchGroupBtnClick:(UIButton *)sender {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 创建一个组队列
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"blk0");
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"blk1");
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"blk2");
    });
    
    /*
     dispatch_group_notify 函数监听dispatch group，全部执行完成之后，执行回调处理
     */
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"done");
    });

}

- (IBAction)dispatchBarrierAsyncBtnClick:(UIButton *)sender {
    /*
     文件的读写为了避免数据竞争，在读取的时候选择 Concurrent Dispatch Queue，
     写入处理在一个读取处理没有的状态下，追加到 Serial Dispatch Queue 中即可（在写入处理结束之前，读取处理不可执行）
     
     GCD 中的 dispatch_barrier_async 函数和dispatch_queue_create 函数生成的 Concurrent Dispatch Queue 一起使用，可以解决这个问题。
     */
    
    // 1、首先 dispatch_queue_create 函数生成 Concurrent Dispatch Queue，在dispatch_async 中追加读取处理
    dispatch_queue_t queue = dispatch_queue_create("com.example.gcd", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"读取文件1");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"读取文件2");
    });
    
    // 2、使用dispatch_barrier_async 函数写入文件，dispatch_barrier_async 会等待追加到该Concurrent Dispatch Queue 上的并行执行的处理全部结束之后，再将指定的处理追加到该 Concurrent Dispatch Queue 中，然后执行写入操作
    dispatch_barrier_async(queue, ^{
        NSLog(@"写入文件");
    });
}


- (IBAction)dispatchSyncBtnClick:(UIButton *)sender {
    /*
     dispatch_sync 同步追加到指定的 Dispatch Queue 中，在追加到 Block 结束之前，dispatch_sync 函数一直会等待，和dispatch_group_wait 函数一样，
     ”等待“意味着当前线程停止。
     */
    
    
    /*
     死锁一
     在主线程中调用该函数会造成死锁。
     在主线程中执行指定的black，并等待其执行结束，而其实在主线程中正在执行这些源代码。
     */
    dispatch_queue_t queue = dispatch_get_main_queue();
//    dispatch_sync(queue, ^{
//        NSLog(@"在主线程中调用dispatch_sync，死锁了......");
//    });

    // 死锁二
//    dispatch_async(queue, ^{
//        dispatch_sync(queue, ^{
//            NSLog(@"死锁了......");
//        });
//    });
    
    // 死锁三，Serial Dispatch Queue
    dispatch_queue_t serialQueue = dispatch_queue_create("com.example.gcd", NULL);
    dispatch_async(serialQueue, ^{
        dispatch_sync(serialQueue, ^{
            NSLog(@"死锁了......");
        });
    });
}




- (IBAction)dispatchApplyBtnClick:(UIButton *)sender {
    
    
}

- (IBAction)dispatchSuspendAndResumeBtnClick:(UIButton *)sender {
    
    
}

- (IBAction)dispatchSemphoreBtnClick:(UIButton *)sender {
    
}


- (IBAction)dispatchOnceBtnClick:(UIButton *)sender {
    
}

- (IBAction)dispatchIOBtnClick:(UIButton *)sender {
    
}




@end
