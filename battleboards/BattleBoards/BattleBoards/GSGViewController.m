//
//  GSGViewController.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GSGViewController.h"

static const int BOMBLBL = 1;
static const int MOVELBL = 2;

@interface GSGViewController ()

@end

@implementation GSGViewController{
    int _bots;
    
}

- (id)initwithGameData:(GameInfo*)gI myid:(NSString *)myid{
    
    _gI = gI;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor redColor];
    
    //max grid size 9
    
    _gridView = [[GridView alloc] initWithFrame:CGRectMake(0,0,320,320) andGridSize:9];
    _gridView.backgroundColor = [UIColor yellowColor];
    _gridView.delegate = self;
    
    _bomb = [UIButton buttonWithType:UIButtonTypeCustom];
    _bomb.frame = CGRectMake(320.0f, 10.0f, 100.0f, 20.0f);
    _bomb.tag = BOMBLBL;
    [_bomb setTitle:@"Set Bombs" forState:UIControlStateNormal];
    [_bomb setSelected:NO];
    [_bomb setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bomb setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_bomb addTarget:self action:@selector(toggleSelection:) forControlEvents:UIControlEventTouchUpInside];

    _move = [UIButton buttonWithType:UIButtonTypeCustom];
    _move.frame = CGRectMake(440.0f, 10.0f, 80.0f, 20.0f);
    _move.tag = MOVELBL;
    [_move setTitle:@"Set Move" forState:UIControlStateNormal];
    [_move setSelected:YES];
    [_move setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_move setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_move addTarget:self action:@selector(toggleSelection:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_bomb];
    [self.view addSubview:_move];
    [self.view addSubview:_gridView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleSelection:(id)sender
{
    if([_move isSelected]){
        
        [_move setSelected:NO];
        [_bomb setSelected:YES];
        
        //do anything else you want to do.
    }
    else {
        
        [_move setSelected:YES];
        [_bomb setSelected:NO];

        //do anything you want to do.
    }
}

@end
