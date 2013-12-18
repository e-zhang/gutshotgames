//
//  GSGViewController.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GSGViewController.h"

@interface GSGViewController ()

@end

@implementation GSGViewController{
    int _bots;
}

- (id)initwithGameData:(GameInfo*)gI myid:(NSString *)myid{

    
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
    
    [self.view addSubview:_gridView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
