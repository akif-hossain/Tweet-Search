//
//  DetailViewController.m
//  Tweet Search
//
//  Created by DEVFLOATER28-XL on 2013-05-08.
//  Copyright (c) 2013 DEVFLOATER28-XL. All rights reserved.
//

#import "DetailViewController.h"
#import "Tweet.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;        
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

//    if (self.detailItem) {
//        self.detailDescriptionLabel.text = [self.detailItem description];
//    }
    
    if (self.detailItem){
        Tweet *tweet = self.detailItem;
        
//        NSString *text = [tweet objectForKey:@"text"];
//        NSString *name = [tweet objectForKey:@"from_user"];
        
        NSString *text = tweet.text;
        NSString *name = tweet.userName;
//        NSString *imageUrl = [tweet objectForKey:@"profile_image_url"];
        NSString *imageUrl = tweet.userImageUrl;

        _tweetLabel.lineBreakMode = UILineBreakModeWordWrap;
        _tweetLabel.numberOfLines = 0;
        [_tweetLabel sizeToFit];
        
        _nameLabel.text = name;
        _tweetLabel.text = text;
        
        if (!(tweet.imageData)){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    tweet.imageData = data;
                    _profileImage.image = [UIImage imageWithData:data];
                });
                
                
            });
        }else{
            _profileImage.image = [UIImage imageWithData:tweet.imageData];
        }
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self configureView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
