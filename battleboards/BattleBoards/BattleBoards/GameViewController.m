//
//  GameViewController.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GameViewController.h"

static const int BOMBLBL = 1;
static const int MOVELBL = 2;


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
        _gridView = [[GridView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               320.0f,
                                                               320.0f)
                                       andGridModel:_gridModel];
        
        [self.view addSubview:_gridView];
        
    }
    return self;
}

-(void)refreshGridPossibilities{

    [_gridModel calculateGridPossibilities];
    [_gridView refreshCosts];
}

-(void) startGame
{
    [_noticeMsg removeFromSuperview];
    [_sidePanel addSubview:_submitButton];
    [_sidePanel addSubview:_roundInfo];
    [_sidePanel addSubview:_activityView];
    
    
    [self refreshGridPossibilities];
}

-(void) updateRoundForCells:(NSArray *)cells andPlayers:(NSDictionary *)players
{
    NSLog(@"upadteRoundforCells-cells-%@,players-%@",cells,players);
    [_activityView stopAnimating];
    
    [_gridView setUserInteractionEnabled:YES];
    [_submitButton setUserInteractionEnabled:YES];
    NSLog(@"...");
    
    for (CoordPoint *p in cells)
    {
        //update cell
        [_gridView updateCell:p];
    }
}


- (void)loadView
{
    // Do any additional setup after loading the view, typically from a nib.
    self.view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 480, 320)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _roundInfo = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 55.0f, 100.0f, 20.0f)];
    _roundInfo.textColor = [UIColor blackColor];
    _roundInfo.text = @"Round -";
    _roundInfo.font = [UIFont systemFontOfSize:10.0f];
    
    _noticeMsg = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, self.view.frame.size.height/2 - 40.0f, self.view.frame.size.width - 100.0f, 80.0f)];
    _noticeMsg.textAlignment = NSTextAlignmentCenter;
    _noticeMsg.backgroundColor = [UIColor blackColor];
    _noticeMsg.textColor = [UIColor whiteColor];
    _noticeMsg.text = @"Select a starting location";
    
    _sidePanel = [[UIView alloc] initWithFrame:CGRectMake(320.0f, 0.0f, self.view.frame.size.width - 320.0f, self.view.frame.size.height)];
    _sidePanel.backgroundColor = [UIColor lightGrayColor];
    
    _activityView =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityView setCenter:CGPointMake(_sidePanel.frame.size.width - 20.0f, 30.0f)];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.backgroundColor = [UIColor blackColor];
    _submitButton.frame = CGRectMake(10.0f, 10.0f, 100.0f, 40.0f);
    [_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitPlay:) forControlEvents:UIControlEventTouchUpInside];
    
    _sidePanel.userInteractionEnabled = YES;
    [_submitButton setUserInteractionEnabled:YES];

    [self.view addSubview:_sidePanel];
    [self.view addSubview:_noticeMsg];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)initPlayer:(Player *)p
{
    NSLog(@"playerupdate-%@",p);
    UIView *charView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 70.0f + 50 * p.GameId, 120.0f, 50.0f)];
    charView.tag = p.GameId;
    
    UIView *charCircle = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 15.0f, 20.0f, 20.0f)];
    charCircle.layer.cornerRadius = 10.0f;
    charCircle.backgroundColor = p.Color;
    
    UILabel *charName = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 0.0f, 120.0f, 50.0f)];
    charName.text = p.Name;
    charName.font = [UIFont systemFontOfSize:10.0f];
    
    [charView addSubview:charCircle];
    [charView addSubview:charName];
    [_sidePanel addSubview:charView];
    
    if([p.Id isEqualToString:_gridModel.MyPlayer.Id])
    {
        UILabel *a = (UILabel *)[_sidePanel viewWithTag:p.GameId + 100];
        
        if(a)
        {
            a.text = [NSString stringWithFormat:@"%d",p.Points];
        }
        else
        {
            UILabel *a = [[UILabel alloc] initWithFrame:CGRectMake(150.0f, 70.0f + 50*p.GameId, 25.0f, 50.0f)];
            a.font = [UIFont systemFontOfSize:10.0f];
            a.tag = p.GameId + 100;
            a.text = [NSString stringWithFormat:@"%d",p.Points];
            [_sidePanel addSubview:a];
        }
        
        [p addObserver:self forKeyPath:@"Points" options:NSKeyValueObservingOptionNew context:nil];
        
        _noticeMsg.text = @"Waiting for players to connect...";
    }
    
    [_gridView updateCell:p.Location];
}

- (void)submitPlay:(id)sender{
    NSLog(@"submit Play");
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [_activityView startAnimating];
    });
    [_gridView setUserInteractionEnabled:NO];
    [_submitButton setUserInteractionEnabled:NO];
    
    [_gridModel submitForMyPlayer];

}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"Points"])
    {
        [self refreshGridPossibilities];
        

        UILabel *a = (UILabel *)[_sidePanel viewWithTag:((Player*)object).GameId + 100];
        if(a)
        {
            a.text = [NSString stringWithFormat:@"%d",((Player*)object).Points];
        }
    }
}


@end