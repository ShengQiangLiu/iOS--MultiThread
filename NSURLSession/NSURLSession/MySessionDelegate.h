//
//  MySessionDelegate.h
//  NSURLSession
//
//  Created by Sniper on 15/12/14.
//  Copyright © 2015年 ShengQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

// 一、简单的代理类接口
typedef void (^CompletionHandlerType)();

@interface MySessionDelegate : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *backgroundSession; // 后台的会话
@property (nonatomic, strong) NSURLSession *defaultSession; // 默认的会话
@property (nonatomic, strong) NSURLSession *ephemeralSession; // 短暂的会话

#if TARGET_OS_IPHONE
@property (nonatomic, strong) NSMutableDictionary *completionHandlerDictionary;
#endif

+ (instancetype)manager;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration;

- (void)addCompletionHandler:(CompletionHandlerType)handler forSession:(NSString *)identifier;
- (void)callCompletionHandlerForSession:(NSString *)identifier;



- (void)downloadWithUrl:(NSString *)url;

@end
