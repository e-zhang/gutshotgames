//
//  GameViewController.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

-(id) initWithGameInfo:(GameInfo *)game playerId:(NSString *)playerId
{
    if([super initWithNibName:nil bundle:nil])
    {
        _gridModel = [[GridModel alloc] initWithGame:game andPlayer:playerId andDelegate:self];
       
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


-(void) updateRoundForCells:(NSArray *)cells andPlayers:(NSDictionary *)players
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:_gridView];
    
    [self postInitialPosition];
}

- (void)postInitialPosition{
    UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, self.view.frame.size.height/2 - 40.0f, self.view.frame.size.width - 100.0f, 80.0f)];
    txt.textAlignment = NSTextAlignmentCenter;
    txt.text = @"Place your initial position.";
    txt.backgroundColor = [UIColor blackColor];
    txt.textColor = [UIColor whiteColor];
    
    [self.view addSubview:txt];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [txt removeFromSuperview];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
