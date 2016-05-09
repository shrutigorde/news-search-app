//
//  MainArticleViewController.h
//  news search
//
//  Created by Shruti Gorde on 5/1/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainArticleViewController : UIViewController

@property (nonatomic,weak) IBOutlet UILabel *lblmainarticle;
@property(retain,nonatomic)NSString *labelarticle;
@property (nonatomic,weak) IBOutlet UILabel *lblmainarticleurl;
@property(weak,nonatomic)NSString *labelarticleurl;
@property (nonatomic,weak) IBOutlet UILabel *lbldatetime;
@property(retain,nonatomic)NSString *datetimestr;

@property (nonatomic,weak) IBOutlet UILabel *lblby;
@property(retain,nonatomic)NSString *strby;
@property(weak,nonatomic)NSString *strtitle;

@property (weak, nonatomic) IBOutlet UINavigationItem *nav_item;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *search;
@property(retain,nonatomic)NSString *imageurlstring;
@property(retain,nonatomic)NSString *imgcaptionstring;
@end
