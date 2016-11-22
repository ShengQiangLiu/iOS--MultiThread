//
//  ViewController.m
//  NSURLSession
//
//  Created by Sniper on 15/12/14.
//  Copyright © 2015年 ShengQiang. All rights reserved.
//

#import "ViewController.h"
#import "MySessionDelegate.h"
#import "MyURLSessionManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    MySessionDelegate *delegate = [MySessionDelegate manager];
//    [delegate downloadWithUrl:@"http://ww2.sinaimg.cn/mw690/51530583jw1es7f5lefy3j21440hsgw8.jpg"];
    
    MyURLSessionManager * manager = [[MyURLSessionManager alloc] init];
    [manager downloadWithUrl:@"http://ww2.sinaimg.cn/mw690/51530583jw1es7f5lefy3j21440hsgw8.jpg"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
