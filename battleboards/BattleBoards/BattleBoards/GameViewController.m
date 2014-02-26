//
//  GameViewController.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GameViewController.h"
#import "Tags.h"

static const int BOMBLBL = 1;
static const int MOVELBL = 2;

static const int PLAYER1TAG = 1001;
static const int PLAYER2TAG = 1002;

static NSString* FORMAT_STRING = @"Round - %d";


@interface GameViewController ()

@end

@implementation GameViewController{
    int _bots;
    
}


- (id)initWithGameInfo:(GameInfo*)game playerId:(NSString *)playerId{
    
    if([super initWithNibName:Nil bundle:Nil])
    {
        _gridModel = [[GridModel alloc] initWithGame:game andPlayer:playerId andDelegate:self];
        NSLog(@"initGVC - gridSize-%@",game.gridSize);
        //screen bounds will make it a rect and not a square

        _gridView = [[GridView alloc] initWithFrame:CGRectMake(10.0f,
                                                              100.0f,
                                                              300.0f,
                                                               300.0f) gridModel:_gridModel andDelegate:self];
        
        [self.view addSubview:_gridView];

        
        [self displayPlayerInfo:game.players];

        
    }
    return self;
}



-(void) startGame
{
    [_noticeMsg removeFromSuperview];
    
    [self.view addSubview:_submitButton];
    [self.view addSubview:_undoButton];
    [self.view addSubview:_roundInfo];
    [self.view addSubview:_activityView];
    
    [_gridView startGame];

    
    // show locations
    for(Player* player in [_gridModel.Players allValues])
    {
        for(Unit* unit in player.Units)
        {
            [_gridView updateCell:unit.Location];
        }
    }
    
    [_gridView refreshCosts:NO];
}

-(void) updateRoundForCells:(NSArray *)cells andPlayers:(NSDictionary *)players
{
    NSLog(@"updateRoundforCells-cells-%@,players-%@",cells,players);
    [_activityView stopAnimating];
    
    [_gridView setUserInteractionEnabled:YES];
    [_submitButton setUserInteractionEnabled:YES];
    [_undoButton setUserInteractionEnabled:YES];
    NSLog(@"...");

    for(CoordPoint *p in cells)
    {
        //update cell
        [_gridView updateCell:p];
    }
    
    NSMutableArray* alive = [[NSMutableArray alloc] initWithCapacity:players.count];
    for(Player* p in [players allValues])
    {
        if(!p.Alive)
        {
            UILabel* label = (UILabel*)[self.view viewWithTag:p.GameId+CHAR_LABEL];
            label.text = @"dead";
        }
        else
        {
            [alive addObject:p];
        }
    }
    
    if(alive.count <= 1)
    {

        NSMutableString* notice = [NSMutableString stringWithFormat:@"Game Over...%@",
                           (alive.count > 0 ? @" Winner is " : @" Draw Between ")];
        
        for(Player* p in alive)
        {
            [notice appendString:p.Name];
            [notice appendString:@" "];
        }
        [self.view addSubview:_noticeMsg];
        _gridView.userInteractionEnabled = NO;
    }
    
}


- (void)loadView
{
    // Do any additional setup after loading the view, typically from a nib.
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor colorWithRed:205.0/255.0f green:205.0/255.0f blue:205.0/255.0f alpha:1];
    
    _roundInfo = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 100.0f, 100.0f, 20.0f)];
    _roundInfo.textColor = [UIColor blackColor];
    _roundInfo.text = [NSString stringWithFormat:FORMAT_STRING,0];
    _roundInfo.font = [UIFont fontWithName:@"GillSans" size:12.0f];
    
    _noticeMsg = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 440.0f, self.view.frame.size.width, 40.0f)];
    _noticeMsg.textAlignment = NSTextAlignmentCenter;
    _noticeMsg.backgroundColor = [UIColor clearColor];
    _noticeMsg.textColor = [UIColor blackColor];
    _noticeMsg.font = [UIFont fontWithName:@"GillSans" size:16.0f];
    _noticeMsg.text = @"Select a starting location";
    
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.backgroundColor = [UIColor blackColor];
    _submitButton.frame = CGRectMake(0.0f, 440.0f, self.view.frame.size.width/2, 40.0f);
    [_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [_submitButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitPlay:) forControlEvents:UIControlEventTouchUpInside];
    
    _undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _undoButton.backgroundColor = [UIColor blackColor];
    _undoButton.frame = CGRectMake(self.view.frame.size.width/2, 440.0f, self.view.frame.size.width/2, 40.0f);
    [_undoButton setTitle:@"Undo" forState:UIControlStateNormal];
    [_undoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_undoButton addTarget:self action:@selector(undoPlay:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setTitle:@"Back" forState:UIControlStateNormal];
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.frame = CGRectMake(self.view.frame.size.width - 70.0f, 10.0f, 70.0f, 50.0f);
    [dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismissVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_noticeMsg];
    [self.view addSubview:dismissButton];

}

- (void)displayPlayerInfo:(NSDictionary*)players{
    
    NSDictionary *player1 = [[players allValues] objectAtIndex:0];
    NSDictionary *player2 = [[players allValues] objectAtIndex:1];
    
    if([[[[players allValues] objectAtIndex:0] objectForKey:@"playerId"]isEqualToString:_gridModel.MyPlayer.Id])
    {
        player1 = [[players allValues] objectAtIndex:0];
        player2 = [[players allValues] objectAtIndex:1];
    }
    else
    {
        player1 = [[players allValues] objectAtIndex:1];
        player2 = [[players allValues] objectAtIndex:0];
    }
    
    NSString *path1 = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [player1 objectForKey:@"fb_id"]];
    NSString *path2 = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square",[player2 objectForKey:@"fb_id"]];
    
    NSURL *url1 = [NSURL URLWithString:path1];
    NSData *data1 = [NSData dataWithContentsOfURL:url1];
    NSData *userPic1 = [NSData dataWithData:data1];

    NSURL *url2 = [NSURL URLWithString:path2];
    NSData *data2 = [NSData dataWithContentsOfURL:url2];
    NSData *userPic2 = [NSData dataWithData:data2];
    
    UIImageView *player1Image = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50.0f, 40.0f, 40.0f, 40.0f)];
    player1Image.tag = PLAYER1TAG;
    player1Image.image = [UIImage imageWithData:userPic1];
    player1Image.layer.cornerRadius = 20.0f;
    player1Image.layer.masksToBounds = YES;
    
    UIImageView *player2Image = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 10.0f, 40.0f, 40.0f, 40.0f)];
    player2Image.tag = PLAYER2TAG;
    player2Image.image = [UIImage imageWithData:userPic2];
    player2Image.layer.cornerRadius = 20.0f;
    player2Image.layer.masksToBounds = YES;
    
    [self.view addSubview:player1Image];
    [self.view addSubview:player2Image];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) onRoundStart:(int)round
{
    _roundInfo.text = [NSString stringWithFormat:FORMAT_STRING, round+1];
    
    [_gridView refreshCosts:NO];
}


-(void)initPlayer:(Player *)p
{

    [p addObserver:self forKeyPath:@"Points" options:NSKeyValueObservingOptionNew context:nil];
    [p addObserver:self forKeyPath:@"SelectedUnit" options:NSKeyValueObservingOptionNew context:nil];
    
    if([p.Id isEqualToString:_gridModel.MyPlayer.Id])
    {
        UILabel *player1points = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 160.0f, 40.0f, 100.0f, 40.0f)];
        player1points.text = [NSString stringWithFormat:@"%d",p.Points];
        player1points.font = [UIFont fontWithName:@"GillSans" size:16.0f];
        player1points.textAlignment = NSTextAlignmentRight;
        player1points.textColor = [UIColor blackColor];
        player1points.tag = p.GameId + CHAR_LABEL;

        [self.view addSubview:player1points];

        _noticeMsg.text = @"Waiting for players to connect...";
        
        UIImageView *player1Image = (UIImageView *)[self.view viewWithTag:PLAYER1TAG];
        player1Image.layer.borderColor = [_gridModel.CharColors[p.GameId] CGColor];
        player1Image.layer.borderWidth = 2.0f;
        
    }
    else
    {
        UILabel *player2points = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 60.0f, 40.0f, 100.0f, 40.0f)];
        player2points.text = [NSString stringWithFormat:@"%d",p.Points];
        player2points.font = [UIFont fontWithName:@"GillSans" size:16.0f];
        player2points.textAlignment = NSTextAlignmentLeft;
        player2points.textColor = [UIColor blackColor];
        player2points.tag = p.GameId + CHAR_LABEL;
        
        [self.view addSubview:player2points];
        
        UIImageView *player2Image = (UIImageView *)[self.view viewWithTag:PLAYER2TAG];
        player2Image.layer.borderColor = [_gridModel.CharColors[p.GameId] CGColor];
        player2Image.layer.borderWidth = 2.0f;
    }
}

-(void) onUnitSelected:(int)unit
{
    [_gridModel.MyPlayer setSelected:unit];
    
    if(unit < 0)
    {
        [_gridView refreshCosts:NO];
    }
    else
    {
        [_gridModel calculateGridPossibilities];
        
        [_gridView refreshCosts:YES];
    }
}


-(void) undoPlay:(id) sender
{
    NSArray* play = [_gridModel undoForMyPlayer];
    
    if(play)
    {
        for(CoordPoint* point in play)
        {
            [_gridView updateCell:point];
        }
    }

}

-(void) dismissVC:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) onUndoBomb:(CoordPoint *)bomb forUnit:(int)unit
{
    NSArray* play = [_gridModel undoBomb:bomb forUnit:unit];
    
    if(play)
    {
        for(CoordPoint* point in play)
        {
            [_gridView updateCell:point];
        }
    }
}


-(void) onUndoMove:(CoordPoint *)move forUnit:(int)unit
{
    NSArray* play = [_gridModel undoMove:move forUnit:unit];
    
    if(play)
    {
        for(CoordPoint* point in play)
        {
            [_gridView updateCell:point];
        }
    }
}


- (void)submitPlay:(id)sender{
    NSLog(@"submit Play");
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [_activityView startAnimating];
    });
    [_gridView setUserInteractionEnabled:NO];
    [_submitButton setUserInteractionEnabled:NO];
    [_undoButton setUserInteractionEnabled:NO];
    
    [_gridModel submitForMyPlayer];

}


-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"Points"])
    {
        Player* player = (Player*) object;
        
        if([player.Id isEqualToString:_gridModel.MyPlayer.Id])
        {
            [_gridView refreshCosts:NO];
        }

        UILabel *a = (UILabel *)[self.view viewWithTag:player.GameId + CHAR_LABEL];

        if(a)
        {
            a.text = [NSString stringWithFormat:@"%d",player.Points];
        }
    }
}


@end
