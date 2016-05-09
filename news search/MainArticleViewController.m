//
//  MainArticleViewController.m
//  news search
//
//  Created by Shruti Gorde on 5/1/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "MainArticleViewController.h"

@interface MainArticleViewController ()

@end

@implementation MainArticleViewController
@synthesize labelarticle,labelarticleurl,strby,strtitle,datetimestr,imageurlstring,imgcaptionstring;
// assign the string values to all uilabels
// set the navigation bar
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
   // NSLog(@"main article string::%@",labelarticle);
    _lblmainarticle.text=labelarticle;
    [_lblmainarticle setNumberOfLines:0];
    CGSize maxSize = CGSizeMake(_lblmainarticle.bounds.size.width, CGFLOAT_MAX);
    CGRect labelRect = [[NSString stringWithFormat:@"%@",labelarticle] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
    _lblmainarticle.frame = CGRectMake(10, 10, labelRect.size.width, labelRect.size.height);
    _lblmainarticle.textAlignment=NSTextAlignmentJustified;
   

    
    //NSLog(@"strby::%@",strby);
    _lbldatetime.text=datetimestr;
    _lblby.text=strby;
    [self.view addSubview:_lbldatetime];
    
    UIImageView *imageurl =[[UIImageView alloc] initWithFrame:CGRectMake(0,350,[UIScreen mainScreen].bounds.size.width,200)];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageurlstring]];
    imageurl.image = [UIImage imageWithData: imageData];
    
    UILabel *lblimgcaption=[[UILabel alloc]initWithFrame:CGRectMake(10, 570, [UIScreen mainScreen].bounds.size.width-20, 70)];
    lblimgcaption.text=imgcaptionstring;
    [lblimgcaption setNumberOfLines:0];
   
    [lblimgcaption sizeToFit];
    
    lblimgcaption.textAlignment=NSTextAlignmentJustified;

    [self.view addSubview:imageurl];
    [self.view addSubview:lblimgcaption];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setNavigationBar{
    CGFloat navBarHeight = 150.0f;
    CGRect frame = CGRectMake(0.0f, 0.0f,self.navigationController.navigationBar.frame.size.width , navBarHeight);
    [self.navigationController.navigationBar setFrame:frame];
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ic_arts.png"] forBarMetrics:UIBarMetricsDefault];

    UIButton *btnback = [[UIButton alloc]initWithFrame:CGRectMake(0, -20, 20, 25)];
    [btnback setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnback addTarget:self action:@selector(PushBack_Click ) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnHome = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.nav_item.leftBarButtonItem= barBtnHome;
    self.nav_item.title=strtitle;
}
-(void)PushBack_Click {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
