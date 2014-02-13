//
//  MasterViewController.m
//  hatenaJ
//
//  Created by Nagasawa Hiroki on 2014/02/11.
//  Copyright (c) 2014年 Nagasawa Hiroki. All rights reserved.
//

#import "MasterViewController.h"
#import "AFNetworking.h"
#import "DDXML.h"
#import "DDXMLElement+Dictionary.h"
#import "SVProgressHUD.h"
#import "DetailViewController.h"
#import "ListViewCell.h"
#import "popularFetcher.h"

@interface MasterViewController () {
    NSMutableArray *_objects,*titleArr,*linkArr,*descriptionArr,*entryImageArr,*hatenaCount;
}

@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation MasterViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.results = [NSMutableArray array];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshAction:)
                  forControlEvents:UIControlEventValueChanged];
    [self refreshAction:nil];
    
    [SVProgressHUD show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshAction:(id)sender
{
    self.isRefresh = YES;
    
    [self requestPopularList];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.results.count;
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self configureCell:indexPath];
}


- (UITableViewCell *)configureCell:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListViewCell";
    ListViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //title
    titleArr = [self.results valueForKeyPath:@"title"];
    //link
    linkArr = [self.results valueForKeyPath:@"link"];
    //description
    descriptionArr = [self.results valueForKeyPath:@"description"];
    //image
    entryImageArr = [self.results valueForKeyPath:@"content:encoded"];
    //hatena:bookmarkcount
    hatenaCount = [self.results valueForKeyPath:@"hatena:bookmarkcount"];
    
    if([titleArr count] > 0) {
        cell.titleLabel.text = [titleArr objectAtIndex:[indexPath row]];
    }else {
        cell.titleLabel.text = @"";
    }
    
    if([linkArr count] > 0) {
        cell.urlLabel.text = [linkArr objectAtIndex:[indexPath row]];
    }else {
        cell.urlLabel.text = @"";
    }

    if([descriptionArr count] > 0) {
        //nullチェック
        if (![[descriptionArr objectAtIndex:[indexPath row]] isEqual:[NSNull null]]) {
            cell.contentLabel.text = [descriptionArr objectAtIndex:[indexPath row]];
        }else{
            cell.contentLabel.text = @"";
        }
    }else {
        cell.contentLabel.text = @"";
    }
    
    //favicon
    NSString* path = @"http://favicon.qfor.info/f/";
    NSString *fav_path = path;
    if([linkArr count] > 0) {
        fav_path = [path stringByAppendingString:[linkArr objectAtIndex:[indexPath row]]];
    }
    NSURL* url = [NSURL URLWithString:fav_path];
    NSData* data = [NSData dataWithContentsOfURL:url];
    UIImage* img = [[UIImage alloc] initWithData:data];
    cell.entryImageView.image = img;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)requestPopularList
{
    __weak MasterViewController *weakSelf = self;
    
    popularFetcher *fetcher = [[popularFetcher alloc] init];
    [fetcher beginFetchPopularList:^(NSDictionary *result, NSError *error) {
        if (!error) {
            weakSelf.results = result[@"rdf:RDF"][@"item"];
            //NSLog(@"result: %@", weakSelf.results);
            [weakSelf.tableView reloadData];
        }
        
        [weakSelf.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSDate *object = _objects[indexPath.row];
        NSString *title = titleArr[indexPath.row];
        NSString *url = linkArr[indexPath.row];
        
        NSMutableArray *items = [NSMutableArray array];
        [items addObject:title];
        [items addObject:url];
        
        [[segue destinationViewController] setDetailItem:items];
    }
}

@end
