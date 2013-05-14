//
//  MasterViewController.h
//  Tweet Search
//
//  Created by DEVFLOATER28-XL on 2013-05-08.
//  Copyright (c) 2013 DEVFLOATER28-XL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController 
//    NSArray *tweets;
@property (strong, nonatomic) NSMutableArray* tweets;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchTweetButton;

- (void)fetchTweets;

@end
