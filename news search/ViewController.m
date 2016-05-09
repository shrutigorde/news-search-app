//
//  ViewController.m
//  news search
//
//  Created by Shruti Gorde on 4/29/16.
//  Updated on 5/3/2016
//  Copyright © 2016 Apple. All rights reserved.
//

#import "ViewController.h"
#import "MainArticleViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    NSMutableArray *Headlinearray;
    NSDateFormatter *dateformatlong;
    NSDateFormatter *dateformat;
    NSDateFormatter *dateformaatmainarticle;
    NSDateFormatter *dateformatmedium;
    NSDateFormatter *todaysdateformat;
    NSString *enddate;

}
/* set uitableview delegate and datasource
 * call the times newswire api
 * reload the table
 */
 - (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"in viewdidload");
    self.SearchBar.hidden=YES;
    self.heightcontraint.constant=0;
    [self.SearchBar setNeedsUpdateConstraints];
    self.table.tableFooterView = [[UIView alloc]init];
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.allowsSelection = true;
    
    [self.view addSubview:self.table];
    [self webServiceCall];
    [self.table reloadData];

}


/* all he date formats are initialized
 * navigation bar is customized and set
 * todays date for article search
 *
 */
-(void)viewWillAppear:(BOOL)animated{
    
    self.txtsearcharticle.delegate=self;
    dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"dd/MM/yyyy hh:mm a"];
    
    dateformaatmainarticle = [[NSDateFormatter alloc] init];
    [dateformaatmainarticle setDateFormat:@"MMMM dd,yyyy hh:mm a"];
    
    dateformatlong = [[NSDateFormatter alloc] init];
    [dateformatlong setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ"];
    [dateformatlong setTimeZone:[NSTimeZone systemTimeZone]];
    [dateformatlong setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    dateformatmedium = [[NSDateFormatter alloc] init];
    [dateformatmedium setTimeZone:[NSTimeZone systemTimeZone]];
    [dateformatmedium setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    todaysdateformat = [[NSDateFormatter alloc] init];
    [todaysdateformat setDateFormat:@"yyyyMMdd"];
    
    NSDate *todaysdate=[NSDate date];
    //NSLog(@"todays date %@",[todaysdateformat stringFromDate:todaysdate]);
    enddate=[todaysdateformat stringFromDate:todaysdate];
    
    [self setNavigationBar];
    
    CGFloat navBarHeight = 65.0f;
    CGRect frame = CGRectMake(0.0f, 0.0f,self.navigationController.navigationBar.frame.size.width , navBarHeight);
    [self.navigationController.navigationBar setFrame:frame];
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

}
//define the setNavigationBar method
-(void)setNavigationBar{
    
   
    NSDictionary *navTitleColor = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor blackColor],NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = navTitleColor;
    
    UIButton *btnsearch = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btnsearch setImage:[UIImage imageNamed:@"ic_search"] forState:UIControlStateNormal];
    [btnsearch addTarget:self action:@selector(Search_Click:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnSearch = [[UIBarButtonItem alloc]initWithCustomView:btnsearch];
    
    self.nav_item.rightBarButtonItem= barBtnSearch;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// search clicked defined
-(void)Search_Click:(UIButton *)sender{
    UIButton *tempbtn=(UIButton *)sender;
    if (tempbtn.selected ==YES) {
        tempbtn.selected=NO;
        [tempbtn setImage:[UIImage imageNamed:@"ic_search.png"] forState:UIControlStateNormal];
        self.heightcontraint.constant=0;
        self.SearchBar.hidden=YES;
        [self.SearchBar setNeedsUpdateConstraints];
        [self webServiceCall];
        [self.table reloadData];
    }
    else{
         tempbtn.selected=YES;
        [tempbtn setImage:[UIImage imageNamed:@"ic_close.png"] forState:UIControlStateNormal];
        self.heightcontraint.constant=46;
        self.SearchBar.hidden=NO;
       
    }

    
}

//text field delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        
        return FALSE;
    }
    return TRUE;
    
}
//text field delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
   }
//text field delegate calls artile areach api after hitting enter
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self articleSearchServiceCall];
    
}

#pragma Tableview methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
     return [Headlinearray count];
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"headline";
    
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
 
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
   
    UILabel *lbltitle=(UILabel *)[cell viewWithTag:2];
    UILabel *lbldatetime=(UILabel *)[cell viewWithTag:100];
//    NSString* foo = [dateformat stringFromDate:[dateformatlong dateFromString:[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"updated_date"] ]] ;
//    NSString* firstarray = [dateformat stringFromDate:[dateformatlong dateFromString:foo] ] ;

    // checks which api is called: times newire or article search
    //enters if statement if times newswire api is called
    if ([ [Headlinearray objectAtIndex:indexPath.row] valueForKey:@"title"]!=nil) {
        lbltitle.text=[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"title"];
       lbldatetime.text=[NSString stringWithFormat:@"%@",[dateformat stringFromDate:[dateformatlong dateFromString:[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"updated_date"] ]]];
    }
    //if article search api is called
    else{
        lbldatetime.text=@"";
        NSLog(@"headlinesarray after table reload::%lu",[Headlinearray count]);
        NSLog(@"main headline::%@",[[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"headline"] valueForKey:@"main"]);
          lbltitle.text=[[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"headline"] valueForKey:@"main"];
         NSLog(@"datetime article::%@",[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"pub_date"] );
        if ([[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"pub_date"] isEqual:[NSNull null]]) {
            lbldatetime.text=@"";
        }
        else{
        lbldatetime.text=[dateformat stringFromDate:[dateformatmedium dateFromString:[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"pub_date"] ] ];
        }

    }
    

    UIImageView *img=(UIImageView *)[cell viewWithTag:1];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
    NSLog(@" headlines array is::%lu",[Headlinearray count ]);

    
    MainArticleViewController *mainarticlevc = (MainArticleViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainArticleViewController"];
    // if times newswire api is called
    if ([[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"title"]!=nil) {
        
        mainarticlevc.labelarticle = [[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"abstract"];
        mainarticlevc.labelarticleurl=[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"url"];
        mainarticlevc.datetimestr=[dateformaatmainarticle stringFromDate:[dateformatlong dateFromString:[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"updated_date"] ]];
        mainarticlevc.strby=[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"byline"];
        mainarticlevc.strtitle=[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"title"];
        if ([[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"multimedia"] isKindOfClass:[NSString class]]) {
         
        }
        else if([[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"multimedia"] isKindOfClass:[NSArray class]]){
            mainarticlevc.imageurlstring=[[[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"multimedia"] objectAtIndex:0]valueForKey:@"url"];
            if ([[[[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"multimedia"] objectAtIndex:0]valueForKey:@"caption"] isEqual:[NSNull null]]) {
                mainarticlevc.imgcaptionstring=@"";
            }
            else{
            mainarticlevc.imgcaptionstring=[[[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"multimedia"] objectAtIndex:0]valueForKey:@"caption"];
            }
            NSLog(@" url::%@  caption::%@",mainarticlevc.imageurlstring,mainarticlevc.imgcaptionstring);

        }
        
    }
    // if article search api is called
    else{
        mainarticlevc.strtitle=[[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"headline"] valueForKey:@"main"];
        mainarticlevc.strby=[[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"byline"] valueForKey:@"original"];
        mainarticlevc.datetimestr=[dateformaatmainarticle stringFromDate:[dateformatmedium dateFromString:[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"pub_date"] ] ];
        mainarticlevc.labelarticle=[NSString stringWithFormat:@"%@     %@",[[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"snippet"] isEqual:[NSNull null]]?@"":[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"snippet"],[[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"lead_paragraph"] isEqual:[NSNull null]]?@"":[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"lead_paragraph"]];
        if ([[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"multimedia"] count]==0) {
            
        }
        else if([[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"multimedia"] count]>0){
            mainarticlevc.imageurlstring=[[[[Headlinearray objectAtIndex:indexPath.row] valueForKey:@"multimedia"] objectAtIndex:0]valueForKey:@"url"];
           
                mainarticlevc.imgcaptionstring=@"";
            
            NSLog(@" url::%@  caption::%@",mainarticlevc.imageurlstring,mainarticlevc.imgcaptionstring);
            
        }
      //  NSLog(@" abstractis ::%@",mainarticlevc.strby);


    
    
    }
    [self.navigationController pushViewController: mainarticlevc animated:YES];
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}
//call the times newswire api
-(void)webServiceCall{
     Headlinearray=[[NSMutableArray alloc] init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    
    [request setURL:[NSURL URLWithString:@"https://api.nytimes.com/svc/news/v3/content/all/all.json?api-key=6ef2b315b02cc50b44d2f7b3ae102bbe:7:74255139"]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting , HTTP status code %li", (long)[responseCode statusCode]);
        
    }
    
      NSLog(@"string::%@",[[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding]);
    NSMutableArray *testFeeds = [NSJSONSerialization JSONObjectWithData:oResponseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"testfeeds:::%@",[testFeeds valueForKey:@"results"]);
    
    [Headlinearray addObjectsFromArray:[testFeeds valueForKey:@"results"]];
    NSLog(@"headline array count %lu",(unsigned long)[Headlinearray count]);
}

//calls the article search api
-(void)articleSearchServiceCall{
    Headlinearray=[[NSMutableArray alloc] init];
    NSString *finalsearchstring=self.txtsearcharticle.text;
    finalsearchstring=[finalsearchstring stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"final search string::%@",finalsearchstring);
    NSString *stringurl=[NSString stringWithFormat:@"http://api.nytimes.com/svc/search/v2/articlesearch.json?q=%@&sort=newest&end_date=%@&api-key=a8457610b68381085a3fff38d6a36337:6:74255139",finalsearchstring,enddate];
  
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    
    [request setURL:[NSURL URLWithString:stringurl]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting , HTTP status code %li", (long)[responseCode statusCode]);
        
    }
    
    NSLog(@"string::%@",[[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding]);
    NSMutableArray *testFeeds = [NSJSONSerialization JSONObjectWithData:oResponseData options:NSJSONReadingMutableContainers error:nil];
   NSLog(@"testfeeds:::%@",[[testFeeds valueForKey:@"response"] valueForKey:@"docs"]);
    
    Headlinearray=[[NSMutableArray alloc] init];
    [Headlinearray addObjectsFromArray:[[testFeeds valueForKey:@"response"] valueForKey:@"docs"]];
    NSLog(@"headline array count %lu",(unsigned long)[Headlinearray count]);
    [self.table reloadData];
}
@end
