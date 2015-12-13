//
//  MyOperationDownloader.h
//  NSOperation
//
//  Created by admin on 15/12/13.
//  Copyright © 2015年 ShengQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOperationDownloader : NSOperation
+ (instancetype)downloadWithUrl:(NSURL *)url success:(void (^)(id responseData))success failure:(void (^)(NSError *error))failure;
@end
