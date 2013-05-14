//
//  MasterViewController.m
//  Tweet Search
//
//  Created by DEVFLOATER28-XL on 2013-05-08.
//  Copyright (c) 2013 DEVFLOATER28-XL. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Tweet.h"
#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (NSMutableArray*) tweets
{
    if (!_tweets){
        _tweets = [[NSMutableArray alloc] init];
    }
    return _tweets;
}

- (void)fetchTweets
{

    //lookup key value coding
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fetching tweets…" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator to place at the bottom of the dialog window.
    indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height - 50);
    [indicator startAnimating];
    [alert addSubview:indicator];
    
    // remove all tweets
    [self.tweets removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: @"http://search.twitter.com/search.json?q=beiber&rpp=25&include_entities=true&result_type=recent"]];
        
        NSError* error;
        
        NSArray* jsonData = [[NSJSONSerialization JSONObjectWithData:data
                                                 options:kNilOptions
                                                   error:&error] valueForKey:@"results"];
        
        for (NSDictionary* obj in jsonData) {
            Tweet* tweet = [[Tweet alloc] init];
            tweet.userName = [obj valueForKey:@"from_user"];
            tweet.text = [obj valueForKey:@"text"];
            tweet.userImageUrl = [obj valueForKey:@"profile_image_url"];
            tweet.createdAt = [obj valueForKey:@"created_at"];
            [self.tweets addObject:tweet];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchTweets];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(searchHashtag:)];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(fetchTweets)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addButton, refreshButton, nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchHashtag:(id)sender
{
    UIAlertView *changeHashAlert = [[UIAlertView alloc] initWithTitle:@"Change HashTag" message:nil delegate:(self) cancelButtonTitle:@"Cancel" otherButtonTitles:@"Search", nil];
    changeHashAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //    [self setChangeHashTextField: [changeHashAlert textFieldAtIndex:0]];
    //    [[self changeHashTextField] setPlaceholder: [self currentHashTag]];
    [changeHashAlert show];
}

//- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//    NSString* newHashTag = [[self changeHashTextField] text];
//    //search button was clicked and hash tag was entered
//    if (buttonIndex == 1 && [newHashTag length] > 0){
//        [self setCurrentHashTag: newHashTag];
//        [self setQuery: nil];
//        [self setTweetList: nil];
//        displayCount = MAX_TWEETS;
//        [self setHashedTitle];
//        [self asyncFetch];
//    }
//}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Tweet *tweet = [_tweets objectAtIndex:indexPath.row];

    NSString *text = tweet.text;
    NSString *name = tweet.userName;
    NSString *imageUrl = tweet.userImageUrl;
    NSString *createdAt = tweet.createdAt;
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"by %@ at %@", name, createdAt];
    cell.imageView.image = [UIImage imageNamed:@"placeholder.png"];
    
    if (!(tweet.imageData)){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                tweet.imageData = data;
                cell.imageView.image = [UIImage imageWithData:data];
            });
        });
    }else{
        cell.imageView.image = [UIImage imageWithData:tweet.imageData];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_tweets removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        NSLog(@"string here");
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showTweet"]) {
        
        NSInteger row = [[self tableView].indexPathForSelectedRow row];
        Tweet *tweet = [_tweets objectAtIndex:row];
        
        DetailViewController *detailController = segue.destinationViewController;
        detailController.detailItem = tweet;
    }
}

@end
