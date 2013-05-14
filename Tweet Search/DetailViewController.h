//
//  DetailViewController.h
//  Tweet Search
//
//  Created by DEVFLOATER28-XL on 2013-05-08.
//  Copyright (c) 2013 DEVFLOATER28-XL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;


@end
