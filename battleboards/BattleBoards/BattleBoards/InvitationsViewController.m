//
//  InvitationsViewController.m
//  sumosmash
//
//  Created by Eric Zhang on 4/29/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import "InvitationsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GameRequest.h"
#import "FeedCell.h"

#import "Tags.h"

@interface InvitationsViewController ()

@property (strong, nonatomic) UITableView *tableView;

@end

#define CELL_SIZE 50

@implementation InvitationsViewController

- (id)initWithFrame:(CGRect)frame invitations:(GameInvitations *)invites
             target:(id)target selector:(SEL)selector
{
    self = [super init];
    if (self) {
        // Custom initialization
     //   UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
     //   [layout setItemSize:CGSizeMake(CELL_SIZE, CELL_SIZE)];
     //   [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
     //   UICollectionView* collection = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
     //   collection.backgroundColor = [UIColor clearColor];
     //   collection.tag = INVITATIONS_VIEW;
        
        _selector = selector;
        _target = target;
        
        _invites = invites;
      //  NSLog(@"%d", [_invites.gameRequests count]);
      //  collection.dataSource = self;
     //   [collection registerClass:[UICollectionViewCell class]
     //                              forCellWithReuseIdentifier:@"game_cell"];
        [invites setDelegate:self];
      //  [collection reloadData];
      //  self.view = collection;
        
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.tag = INVITATIONS_VIEW;
        self.tableView.frame = frame;
        self.tableView.scrollsToTop = YES;
        self.tableView.userInteractionEnabled = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self.view = self.tableView;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidUnload
{
    [_invites releaseDelegate];
}


-(void) onInviteReceived:(NSArray *)invites
{
  /*  int numRows = [self.tableView numberOfRowsInSection:0];
    int count = [invites count];
    NSMutableArray* paths = [[NSMutableArray alloc] initWithCapacity:count-numRows];
    
    for(int i = numRows; i < count; ++i)
    {
        [paths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];*/
    [self.tableView reloadData];

}

-(void) gotogame:(NSInteger)i
{
    GameRequest* game = [[GameRequest alloc] initWithProperties:
                         [_invites.gameRequests objectAtIndex:i]];
    
    [_target performSelector:_selector withObject:game];
}

// UICollectionViewDataSource

// 1
//- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
//    return [_invites.gameRequests count];
//}
// 2
//- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
//    return 1;
//}
// 0
/*- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"game_cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UIButton* web;
    if([[cell.contentView subviews] count] == 0)
    {
        UIButton *web = [[UIButton alloc] init];
        web.tag = indexPath.row;
        web.frame = CGRectMake(0,0,CELL_SIZE, CELL_SIZE);
        cell.layer.borderColor = [[UIColor blackColor] CGColor];
        cell.layer.borderWidth = 1.5;
        [web setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        web.titleLabel.font = [UIFont systemFontOfSize:8.0];
        web.titleLabel.numberOfLines = 2;
        [web setTitle:[[_invites.gameRequests objectAtIndex:indexPath.row] objectForKey:GAME_ID] forState:UIControlStateNormal];
        [web addTarget:self action:@selector(gotogame:) forControlEvents:UIControlEventTouchUpInside];
        web.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:web];
    }
    else
    {
        web = (UIButton*)[[cell.contentView subviews] objectAtIndex:0];
        [web setTitle:[[_invites.gameRequests objectAtIndex:indexPath.row] objectForKey:GAME_ID] forState:UIControlStateNormal];
        web.tag = indexPath.row;
    }
    
    GameRequest* game = [[GameRequest alloc] initWithProperties:
                         [_invites.gameRequests objectAtIndex:indexPath.row]];
    [web setTitle:game.game_id forState:UIControlStateNormal];
    
    return cell;
}*/


- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return [_invites.gameRequests count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 60;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    FeedCell *cell = (FeedCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell-ID"];
    
    if (cell == nil) {
        
        cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell-ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    NSLog(@"dprw-%@",_invites.gameRequests);
    
    NSDictionary* request = [_invites.gameRequests objectAtIndex:([_invites.gameRequests count] - 1 - indexPath.row)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path1 = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [request objectForKey:@"hostfbid"]];
       
        NSData *name = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@", [request objectForKey:@"hostfbid"]]]];
        
        NSURL *url1 = [NSURL URLWithString:path1];
        NSData *data1 = [NSData dataWithContentsOfURL:url1];
        NSData *userPic1 = [NSData dataWithData:data1];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            cell.profileImageView.image = [UIImage imageWithData:userPic1];
        });
    });
    
    cell.topText.text = [request objectForKey:@"game_id"];
    
    NSString* dateString = [request objectForKey:@"dateCreated"];
    if([request objectForKey:@"dateCreated"])
    {
        
        NSTimeZone* tz = [NSTimeZone defaultTimeZone];
        NSDateFormatter* format = [[NSDateFormatter alloc] init];

        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];

        NSDate* date = [format dateFromString:dateString];
        [format setTimeZone:tz];
        cell.bottomText.text = [self getDisplayTime:date];
    }
    else
        cell.bottomText.text = @"";
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [self gotogame:([_invites.gameRequests count] - 1 - indexPath.row)];
}

-(NSString*)getDisplayTime:(NSDate*)date{
    
    NSString *returnValue;
    
    NSDate* date1 = [NSDate date];
    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date];
    
    double a = 1;
    
    NSInteger seconds = distanceBetweenDates / a;
    
    if(seconds<60)
        returnValue = [NSString stringWithFormat:@"%ld secs",(long)seconds];
    else if(seconds<60*60)
        returnValue = [NSString stringWithFormat:@"%ld mins",(long) (seconds/60)];
    else if(seconds<60*60*60)
        returnValue = [NSString stringWithFormat:@"%ld hrs",(long) (seconds/3600)];
    else if(seconds<60*60*60*24)
        returnValue = [NSString stringWithFormat:@"%ld days",(long) (seconds/(3600*24))];
    
    return returnValue;
}

@end
