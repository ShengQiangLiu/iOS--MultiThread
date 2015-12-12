###一、Dispatch Queue 概念
Dispatch Queue 是执行处理的等待队列。可以将想执行的处理追加到 Dispatch Queue 中，Dispatch Queue 按照追加的顺序（FIFO）执行处理。

![image](/O2O.jpg)

###二、两种 Dispatch Queue 
Serial Dispatch Queue 串行分发队列
Concurrent Dispatch Queue 并行分发队列

###三、如何创建 Dispatch Queue
1、dispatch_queue_create 函数生成 Dispatch Queue。

2、或者系统标准提供的：
Main Dispatch Queue 和 Global Dispatch Queue 这两种。

Main Dispatch Queue 属于 Serial Dispatch Queue，因为是Main。

Global Dispatch Queue 属于 Concurrent Dispatch Queue，因为是整个应用都可以使用的。它有四种优先级：High priority、Default priority、Low Priority、Background Priority。

**Dispatch Queue 的名称推荐使用应用程序ID这种逆序全程域名（FQDN，fully qualified domain name）**

###四、GCD API
1、dispatch_set_target_queue 函数

使用 dispatch_set_target_queue 变更生成 Dispatch Queue 的优先级

    dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("com.example.gcd", NULL);
    dispatch_queue_t globalDispatchQueueBackground = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    // 使用 dispatch_set_target_queue 变更生成 Dispatch Queue 的优先级
    dispatch_set_target_queue(mySerialDispatchQueue, globalDispatchQueueBackground);

2、dispatch_after 函数

dispatch_after 函数指定时间追加处理到 Dispatch Queue

    // 在当前时间，延迟 3 秒到主线程执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"延迟3秒执行");
    });
3、Dispatch Group 

追加到 Dispatch Queue 中的多个处理全部结束后需要执行结束处理，这个时候就要用到 Dispatch Group

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    // dispatch_group_async 函数与 dispatch_async 函数相同，都追加 Block 到指定的 Dispatch Queue 中，唯一的区别是 dispatch_group_async 函数第一个参数指定这个线程属于的 Dispatch Group
    dispatch_group_async(group, queue, ^{
        NSLog(@"group 1");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"group 2");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"group 3");
    });
    // dispatch_group_notify 函数监听 Dispatch Group，一旦所有线程执行完，它将执行block
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"三个线程全部执行完了");
    });
    // 或者使用 dispatch_group_wait 函数
	//    long result = dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
	//    if (result == 0) {
	//        NSLog(@"线程全部执行完。");
	//    } else {
	//        NSLog(@"Group中的一个线程还在执行中。");
	//    }


