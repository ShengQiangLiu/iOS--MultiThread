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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    
    [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:kUrl];
}

-(void)viewDidLayoutSubviews
{
    self.imageView.frame = self.view.bounds;
}

- (void)downloadImage:(NSString *)url
{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [[UIImage alloc] initWithData:data];
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
    
}

- (void)updateUI:(UIImage *)image
{
    self.imageView.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
