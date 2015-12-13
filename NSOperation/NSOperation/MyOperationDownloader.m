//
//  MyOperationDownloader.m
//  NSOperation
//
//  Created by admin on 15/12/13.
//  Copyright © 2015年 ShengQiang. All rights reserved.
//

#import "MyOperationDownloader.h"

static NSString *const kUGGIsFinished = @"isFinished";
static NSString *const kUGGIsExecuting = @"isExecuting";

@interface MyOperationDownloader () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSMutableData *responseData;


@property (nonatomic, assign) BOOL finished;
@property (nonatomic, assign) BOOL executing;
@end

@implementation MyOperationDownloader
@synthesize finished;
@synthesize executing;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lock = [[NSRecursiveLock alloc] init];
        self.lock.name = @"com.mynetwork.lock";
        self.timeInterval = 10.0f;
    }
    return self;
}

+ (instancetype)downloadWithUrl:(NSURL *)url success:(void (^)(id responseData))success failure:(void (^)(NSError *error))failure
{
    MyOperationDownloader *download = [[MyOperationDownloader alloc] init];
    download.url = url;
    [download downloadCompletionBlockWithSuccess:success failure:failure];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:3];
    [queue addOperation:download];

    return download;
}

// 设置下载完成后的回调
- (void)downloadCompletionBlockWithSuccess:(void (^)(id responseData))success
                                   failure:(void (^)(NSError *error))failure {
    [self.lock lock];
    __weak typeof(self) weakSelf = self;
    self.completionBlock = ^ {
        if (weakSelf.error) {
            if (failure) {
                failure(weakSelf.error);
            }
        } else {
            if (success) {
                success(weakSelf.responseData);
            }
        }
    };
    [self.lock unlock];
}

#pragma mark - start相关方法
+ (NSThread *)networkThread {
    static NSThread *_networkThread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkEntry:) object:nil];
        [_networkThread start];
    });
    return _networkThread;
}

+ (void)__attribute__((noreturn))networkEntry:(id)__unused object {
    do {
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] run];
        }
    } while (YES);
}

- (void)operationDidStart {
    [self.lock lock];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeInterval];
    [request setHTTPMethod:@"GET"];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.connection start];
    [self.lock unlock];
}

- (void)operationDidFinish {
    [self.lock lock];
    [self willChangeValueForKey:kUGGIsFinished];
    [self willChangeValueForKey:kUGGIsExecuting];
    self.executing = NO;
    self.finished = YES;
    [self didChangeValueForKey:kUGGIsExecuting];
    [self didChangeValueForKey:kUGGIsFinished];
    [self.lock unlock];
}




#pragma mark - 重载 NSOperation 父类方法
- (void)start
{
    [self.lock lock];
    
    if ([self isCancelled]) {
        [self willChangeValueForKey:kUGGIsFinished];
        self.finished = YES;
        [self didChangeValueForKey:kUGGIsFinished];
    }
    [self willChangeValueForKey:kUGGIsExecuting];
    [self performSelector:@selector(operationDidStart) onThread:[[self class] networkThread] withObject:nil waitUntilDone:NO];
    self.executing = YES;
    [self willChangeValueForKey:kUGGIsExecuting];
    
    [self.lock unlock];

}

- (void)cancel
{
    [self.lock lock];
    [super cancel];
    if (self.connection) {
        [self.connection cancel];
        self.connection = nil;
    }
    [self.lock unlock];
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return self.executing;
}

- (BOOL)isFinished
{
    return self.finished;
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (![response respondsToSelector:@selector(statusCode)] || [httpResponse statusCode] < 400) {
        NSUInteger expectedSize = httpResponse.expectedContentLength > 0 ? (NSUInteger)response.expectedContentLength : 0;
        // 记得初始化接受数据
        self.responseData = [[NSMutableData alloc] initWithCapacity:expectedSize];
    } else {
        [connection cancel];
        NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:[httpResponse statusCode] userInfo:nil];
        self.error = error;
        self.connection = nil;
        self.responseData = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.connection = nil;
    self.error = nil;
    [self operationDidFinish];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.connection = nil;
    self.responseData = nil;
    self.error = error;
    [self operationDidFinish];
}


@end
