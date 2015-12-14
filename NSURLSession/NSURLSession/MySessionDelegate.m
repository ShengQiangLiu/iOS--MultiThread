//
//  MySessionDelegate.m
//  NSURLSession
//
//  Created by Sniper on 15/12/14.
//  Copyright © 2015年 ShengQiang. All rights reserved.
//

#import "MySessionDelegate.h"

@implementation MySessionDelegate

+ (instancetype)manager
{
    return [[[self class] alloc] initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    return [self initWithBaseURL:url sessionConfiguration:nil];
}

// 二、session 配置
- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super init];
    if (!self)return nil;
    
#if TARGET_OS_IPHONE
    self.completionHandlerDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
#endif
    
    // 创建 comfiguration 对象
    NSURLSessionConfiguration *backgroundConfigObject = [NSURLSessionConfiguration backgroundSessionConfiguration: @"myBackgroundSessionIdentifier"];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSessionConfiguration *ephemeralConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    /*
     *  配置default session 缓存行为
     *  iOS 缓存到相对(relative)路径，~/Library/Caches 目录，但是 OS X 是一个绝对(absolute)路径
     */
#if TARGET_OS_IPHONE
    NSString *cachePath = @"/MyCacheDirectory";
    NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *myPath = [myPathList  objectAtIndex:0];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *fullCachePath = [[myPath stringByAppendingPathComponent:bundleIdentifier] stringByAppendingPathComponent:cachePath];
    NSLog(@"Cache path: %@\n", fullCachePath);
#else
    NSString *cachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/nsurlsessiondemo.cache"];
    NSLog(@"Cache path: %@\n", cachePath);
#endif
    NSURLCache *myCache = [[NSURLCache alloc] initWithMemoryCapacity: 16384 diskCapacity: 268435456 diskPath: cachePath];
    defaultConfigObject.URLCache = myCache;
    defaultConfigObject.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    
    ephemeralConfigObject.allowsCellularAccess = NO;

    
    // 初始化 Session
    self.defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    self.backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    self.ephemeralSession = [NSURLSession sessionWithConfiguration:ephemeralConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];

    // 创建第二个 ephemeral session
    NSURLSession *ephemeralSessionWiFiOnly = [NSURLSession sessionWithConfiguration: ephemeralConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    return self;
}

// 三、任务下载
- (void)downloadWithUrl:(NSString *)url
{
    NSURL *myurl = [NSURL URLWithString:url];
    NSURLSessionDownloadTask *downloadTask = [self.backgroundSession downloadTaskWithURL: myurl];
    [downloadTask resume];
}

//- (void)addCompletionHandler:(CompletionHandlerType)handler forSession:(NSString *)identifier
//{
//    
//}
//
//- (void)callCompletionHandlerForSession:(NSString *)identifier
//{
//    
//}

// 四、代理方法实现
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"Session %@ download task %@ finished downloading to URL %@\n",
          session, downloadTask, location);
#if 0
    /* Workaround */
    [self callCompletionHandlerForSession:session.configuration.identifier];
#endif

#define READ_THE_FILE 0
#if READ_THE_FILE
    /* Open the newly downloaded file for reading. */
    NSError *err = nil;
    NSFileHandle *fh = [NSFileHandle fileHandleForReadingFromURL:location
                                                           error: &err];
    
    /* Store this file handle somewhere, and read data from it. */
    // ...
    
#else
    NSError *err = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheDir = [[NSHomeDirectory()
                           stringByAppendingPathComponent:@"Library"]
                          stringByAppendingPathComponent:@"Caches"];
    NSURL *cacheDirURL = [NSURL fileURLWithPath:cacheDir];
    if ([fileManager moveItemAtURL:location
                             toURL:cacheDirURL
                             error: &err]) {
        
        /* Store some reference to the new URL */
    } else {
        /* Handle the error. */
    }
#endif
    
    
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"Session %@ download task %@ wrote an additional %lld bytes (total %lld bytes) out of an expected %lld bytes.\n",
          session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"Session %@ download task %@ resumed at offset %lld bytes out of an expected %lld bytes.\n",
          session, downloadTask, fileOffset, expectedTotalBytes);
}


// 后台活动
#if TARGET_OS_IPHONE
-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"Background URL session %@ finished events.\n", session);
    
    if (session.configuration.identifier)
    {
        [self callCompletionHandlerForSession: session.configuration.identifier];
    }
}

- (void)addCompletionHandler: (CompletionHandlerType) handler forSession: (NSString *)identifier
{
    if ([ self.completionHandlerDictionary objectForKey: identifier])
    {
        NSLog(@"Error: Got multiple handlers for a single session identifier.  This should not happen.\n");
    }
    
    [ self.completionHandlerDictionary setObject:handler forKey: identifier];
}

- (void)callCompletionHandlerForSession: (NSString *)identifier
{
    CompletionHandlerType handler = [self.completionHandlerDictionary objectForKey: identifier];
    
    if (handler)
    {
        [self.completionHandlerDictionary removeObjectForKey: identifier];
        NSLog(@"Calling completion handler.\n");
        
        handler();
    }
}
#endif








@end










