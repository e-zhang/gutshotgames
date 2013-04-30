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

@interface InvitationsViewController ()

@end

@implementation InvitationsViewController

- (id)initWithFrame:(CGRect)frame invitations:(GameInvitations *)invites
             target:(id)target selector:(SEL)selector
{
    self = [super init];
    if (self) {
        // Custom initialization
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(75, 75)];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.view = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        self.view.backgroundColor = [UIColor clearColor];
        self.view.tag = INVITATIONS_TAG;
        
        _selector = selector;
        _target = target;
        
        _invites = invites;
        [invites setDelegate:self];
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
    UICollectionView* collection = (UICollectionView*)self.view;
    int numRows = [collection numberOfItemsInSection:0];
    int count = [invites count];
    NSMutableArray* paths = [[NSMutableArray alloc] initWithCapacity:count-numRows];
    
    for(int i = numRows; i < count; ++i)
    {
        [paths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [collection insertItemsAtIndexPaths:paths ];

}

-(void) gotogame:(UIButton*)sender
{
    GameRequest* game = [[GameRequest alloc] initWithProperties:
                         [_invites.gameRequests objectAtIndex:sender.tag]];
    
    [_target performSelector:_selector withObject:game];
}

// UICollectionViewDataSource

// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [_invites.gameRequests count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 0
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"invite_cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UIButton* web = (UIButton*)[[cell.contentView subviews] objectAtIndex:0];
    if(!web)
    {
        UIButton *web = [[UIButton alloc] init];
        web.tag = indexPath.row;
        web.frame = CGRectMake(0,0,50,50);
        [web setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        web.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [web addTarget:self action:@selector(gotogame:) forControlEvents:UIControlEventTouchUpInside];
        web.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:web];
    }
    
    GameRequest* game = [[GameRequest alloc] initWithProperties:
                         [_invites.gameRequests objectAtIndex:indexPath.row]];
    [web setTitle:game.game_id forState:UIControlStateNormal];
    
    return cell;
}

@end
