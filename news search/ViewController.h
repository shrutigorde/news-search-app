//
//  ViewController.h
//  news search
//
//  Created by Shruti Gorde on 4/29/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainArticleViewController.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UINavigationItem *nav_item;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *search;
@property (weak, nonatomic) IBOutlet UIView *SearchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightcontraint;

@property (weak, nonatomic) IBOutlet UITextField *txtsearcharticle;
@end

