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

@implementation GSGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor redColor];
    
    //max grid size 9
    
    GridView *view = [[GridView alloc] initWithFrame:CGRectMake(0,0,320,320) andGridSize:9];
    view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
