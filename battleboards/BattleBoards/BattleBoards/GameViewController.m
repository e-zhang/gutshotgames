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

<<<<<<< HEAD
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
=======
- (id)initWithGameInfo:(GameInfo*)gI playerId:(NSString *)myid{
    
    if([super init])
    {
        _gridModel = [[GridModel alloc] initWithGame:gI andPlayer:myid andDelegate:self];
    }
    return self;
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor redColor];
    
    //max grid size 9
    
    _gridView = [[GridView alloc] initWithFrame:CGRectMake(0,0,320,320) withGridModel:_gridModel];
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

-(void)updateRoundForCells:(NSArray *)cells andPlayers:(NSDictionary *)players
{
    
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
<<<<<<< HEAD
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
=======
    else {
        
        [_move setSelected:YES];
        [_bomb setSelected:NO];
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae

        //do anything you want to do.
    }
}

@end
