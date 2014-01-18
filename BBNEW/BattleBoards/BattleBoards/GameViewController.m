//
//  GameViewController.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GameViewController.h"
#import "CoordPoint.h"
#include "DBDefs.h"
#include "CharColors.h"

@interface GameViewController ()

@end

@implementation GameViewController

-(id) initWithGameInfo:(GameInfo *)game playerId:(NSString *)playerId
{
    if([super initWithNibName:nil bundle:nil])
    {
        _gridModel = [[GridModel alloc] initWithGame:game andPlayer:playerId andDelegate:self];
        NSLog(@"initGVC - gridSize-%@",game.gridSize);
        //screen bounds will make it a rect and not a square
        _gridView = [[GridView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               320.0f,
                                                               320.0f)
                                            withSize:[game.gridSize intValue]
                                            andGridModel:_gridModel];
    }
    
    return self;
}

-(void)startNextRound:(int)roundNum{
    
    [_gridView setUserInteractionEnabled:YES];
    [_submitButton setUserInteractionEnabled:YES];
    
    _roundInfo.text = [NSString stringWithFormat:@"Round %d",roundNum];
  //  [_gridView startNR];
}

-(void)showMovePossibilities{
    [_gridView showMoveP];
}

-(void)showBombPossibilities{
    [_gridView showBombP];
}

-(void) updateRoundForCells:(NSArray *)cells andPlayers:(NSDictionary *)players andRound:(int)roundNum
{
    NSLog(@"upadteRoundforCells-roundNum%d-cells-%@,players-%@",roundNum,cells,players);
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

-(void) refreshCellatRow:(int)x andCol:(int)y{
    NSLog(@"ref called");
    CoordPoint *coord = [CoordPoint coordWithX:x andY:y];
    [_gridView updateCell:coord];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.frame = CGRectMake(0.0f, 0.0f, 568.0f, 320.0f);
    self.view.backgroundColor = [UIColor whiteColor];
    
    _roundInfo = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 55.0f, 100.0f, 20.0f)];
    _roundInfo.textColor = [UIColor blackColor];
    _roundInfo.text = @"Round -";
    _roundInfo.font = [UIFont systemFontOfSize:10.0f];
    
    _noticeMsg = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, self.view.frame.size.height/2 - 40.0f, self.view.frame.size.width - 100.0f, 80.0f)];
    _noticeMsg.textAlignment = NSTextAlignmentCenter;
    _noticeMsg.backgroundColor = [UIColor blackColor];
    _noticeMsg.textColor = [UIColor whiteColor];
    
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

    [self.view addSubview:_gridView];
    [self.view addSubview:_sidePanel];
    [self.view addSubview:_noticeMsg];
    
    [self showConnectingScreen];
    [_gridModel beginGame];

}

- (void)startGame{
    
    [_noticeMsg removeFromSuperview];
    [_sidePanel addSubview:_submitButton];
    [_sidePanel addSubview:_roundInfo];
    [_sidePanel addSubview:_activityView];

}


- (void)showConnectingScreen{
    _noticeMsg.text = @"Waiting for all players to connect...";
}

- (void)initplayers:(NSDictionary*)players{

    int a = 0;
    for (id player in players)
    {
        NSLog(@"initplayer");
        NSDictionary *data = [players objectForKey:player];
      
        UIView *charView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 70.0f + 50 * a, 120.0f, 50.0f)];
        charView.tag = [[data objectForKey:INGAMEID] integerValue];
        
        UIView *charCircle = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 15.0f, 20.0f, 20.0f)];
        charCircle.layer.cornerRadius = 10.0f;
        switch(charView.tag)
        {
            case 1:
                charCircle.backgroundColor = player1Color;
                break;
            ;
            case 2:
                charCircle.backgroundColor = player2Color;
                break;
            ;
            case 3:
                charCircle.backgroundColor = player3Color;
                break;
            ;
            case 4:
                charCircle.backgroundColor = player4Color;
                break;
            ;
            case 5:
                charCircle.backgroundColor = player5Color;
                break;
            ;
        }

        UILabel *charName = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 0.0f, 120.0f, 50.0f)];
        charName.text = [data objectForKey:@"name"];
        charName.font = [UIFont systemFontOfSize:10.0f];
        
        [charView addSubview:charCircle];
        [charView addSubview:charName];
        [_sidePanel addSubview:charView];
        a++;
    }
}

-(void)playerupdate:(NSString *)pId newpoints:(int)points withPlayers:(NSDictionary *)players{
    
    int i = 0;
    for (NSString* player in players)
    {
        NSLog(@"playerupdate-%@-pId-%@",player,pId);
        if([player isEqualToString:pId])
        {
            NSDictionary *data = [players objectForKey:player];
            
            UILabel *a = (UILabel *)[_sidePanel viewWithTag:[[data objectForKey:INGAMEID] integerValue] + 100];
            
            if(a)
            {
                a.text = [NSString stringWithFormat:@"%d",points];
            }
            else
            {
                UILabel *a = [[UILabel alloc] initWithFrame:CGRectMake(150.0f, 70.0f + 50 * i, 25.0f, 50.0f)];
                a.font = [UIFont systemFontOfSize:10.0f];
                a.tag = [[data objectForKey:INGAMEID] integerValue] + 100;
                a.text = [NSString stringWithFormat:@"%d",points];
                [_sidePanel addSubview:a];
            }
            
            break;
        }
        
        i++;
    }

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
