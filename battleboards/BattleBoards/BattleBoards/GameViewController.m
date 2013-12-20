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

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
             gameInfo:(GameInfo *)game playerId:(NSString *)playerId
{
    if([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        _gridModel = [[GridModel alloc] initWithGame:game andPlayer:playerId];
        _gridView = [[GridView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               [UIScreen mainScreen].bounds.size.width,
                                                               [UIScreen mainScreen].bounds.size.height)
                                            withSize:[game.gridSize intValue]
                                            andGridModel:_gridModel];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
