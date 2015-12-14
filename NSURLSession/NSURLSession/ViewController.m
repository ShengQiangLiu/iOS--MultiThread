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
//    [delegate downloadWithUrl:@"http://baichuan.baidu.com/redirecting?key=xBeqA2UCVL0eOLDvOvH2OLHvDvPvCoCnxEUnx3SCVL01DZOqDBD0VdA0VYt0OZCqAcxaOcKjOcPzAZD5GYb2OXVtx3KCVL0eOcbeOLJ1OvJ1CdItUQnzVY0eCdCwVIS5xBH9OFV0k2ynkc0zDYb5OYAvDX05VYKnNYSnGLDyGLCqVF05AvA2VYqdVdH2VcHdxdIhVB9yWYDzDdHvDLDzDvMvDcDeDvPdpQCnVc1glQSzCYOKCYCBCYCBxoSjNdCnpBHhA29yCYCBA2fnD0VwkdVuCYOMR1K5xtq4SMUfV1IVFonCF01rREnOUMt1YZwUDM1Yk0SVkH5dYZlumM1MFElGmtH0Ydwcl09OH0IrlYCckBb5R0UQFdwAmtHzYEwOD05HZYKGUM16YHSGFFHaOYCBCYJ1DtAnDcHaSjHaOYCBCYJ1DtAnDcHaSjHaOYCBCYJ1DtAnDcHaSjHaOYCBCYJ1DtAnDcHaStIZFZlGUMVrZUSXpt5QZd1GS1H1YtSZpUnEFYOOpnn3ZZwVl01QSdwWUBf0YdwFAHOrSYKGUMI3YZwomM1HAnnKHHSoRUnLptCnV0JnDcHaRowAl0ISkHOKkQSuVMqFl09wGQVcS3qgVUD1pUnEkBytHvUrAcJzldOQmBqnU1V5YLOGDInAHoKVmYnuVMxex0zvFoKpDdbzHUlFVnnyYEUqFIC0AtR5xIwMDQqGSM16YowUDt5MUEwOmtI6ZLOCOM1HUEqGmtM1YtSODM9HHEUGSItepZlCSnSESdwHDH9YRZltS2IAFdepkYt0k2lCUt1LOQlOSMMeYUSCD05HZdVGHvReYdwUl05ZGUUeRHnKx0INkQIVp1S1RHnKl0IDScOzpEKXlMULR2JnDcHaSowvFoqLSdyMZHIoFBlKV0MnDcHvSXHaOdeqkdSwkdxnD0SglQSzCYJ1D0MnDcHaSjHaOYCBAdS0VaHaOYCIGYUsCYJ1DtUck20nDcHaSoDnDcHaScMnDcHaScJeDvDnDcHaScRvDLM1CYJ1DtUglB1fCYJ1D0V1pZRnDcHvSXHaOYJ1CYJ1DcUWFHSMY01KFH4nDcHaOFHaOYJ1CdnvSBnvWYH=&referUrl=http%3A%2F%2Fplay.baidu.com%2F&curUrl=http%3A%2F%2Fplay.baidu.com%2Fplayer%2Fstatic%2Fhtml%2FrightAd_bc.html%3Fid%3D1433756453303_r815170943494.465"];
    
    MyURLSessionManager * manager = [[MyURLSessionManager alloc] init];
    [manager downloadWithUrl:@"http://cdn1.raywenderlich.com/wp-content/uploads/2013/09/networking13.png"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
