//
//  GridCell.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GridCell.h"
#import "CellValue.h"
#import <QuartzCore/QuartzCore.h>

@implementation GridCell

- (id)initWithFrame:(CGRect)frame andGrid:(GridModel *)grid andCoord:(CoordPoint *)coord
{
    self = [super initWithFrame:frame];
    if (self) {

        _grid = grid;
        _cell = coord;
        
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0f;
        
        _view = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, self.frame.size.width - 10.0f, self.frame.size.height - 10.0f)];
        _view.layer.cornerRadius = (self.frame.size.width - 10.0f) / 2;
        
        _cost = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f,self.frame.size.width, self.frame.size.height)];
        _cost.textAlignment = NSTextAlignmentCenter;
        _cost.textColor = [UIColor blackColor];
        _cost.text = @"";

        [self addSubview:_view];
        [self addSubview:_cost];
    }
    return self;
}

<<<<<<< HEAD
=======
- (void)drawMyDot
{
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, self.frame.size.width - 10.0f, self.frame.size.height - 10.0f)];
    circle.tag = SELF;

    circle.layer.cornerRadius = (self.frame.size.width - 10.0f) / 2;
    [self addSubview:circle];
}
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    

    CellValue* cellV = [_grid getCellAtRow:_cell.x andCol:_cell.y];
<<<<<<< HEAD
    NSLog(@"displayCellState-%d%d--%d-MOVECOST%d",_cell.x,_cell.y,cellV.state,cellV.moveCost);
    NSLog(@"displayCellState-%d%d--%d-BOMBCOST%d",_cell.x,_cell.y,cellV.state,cellV.bombCost);

    switch (cellV.state)
    {
        case INIT:
        {
            [_grid makeAllInit];
            [_grid initailizePositionatRow:_cell.x andCol:_cell.y];
            _view.backgroundColor = player1Color;
            break;
        }
=======
    NSLog(@"displayCellState-%d%d--%d",_cell.x,_cell.y,cellV.state);
    
    switch (cellV.state)
    {
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
        case OCCUPIED:
        {
            NSLog(@"occupied-occupants-%@",cellV.occupants);
            if([_cell isEqual:_grid.MyPlayer.Location])
            {
                [_grid showMovePs];

            }
            break;
        }
        case BOMB:
            break;
        case EMPTY:
        {
            [_grid cellTap:_cell.x andCol:_cell.y];
        }
            break;
        case GONE:
            break;
        default:
            break;
    }
}

/*
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{}
*/

-(void) update
{

<<<<<<< HEAD
    NSLog(@"update-called-%d%d-%d",_cell.x,_cell.y,cell.state);
    
=======
    CellValue* cell = [_grid getCellAtRow:_cell.x andCol:_cell.y];
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
    switch(cell.state)
    {
        case EMPTY:
        {
<<<<<<< HEAD
            NSLog(@"removeView4321");
            [_view setHidden:YES];
=======
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
            self.layer.borderColor = [UIColor blackColor].CGColor;
            self.backgroundColor = [UIColor whiteColor];
            break;
        }
        case BOMB:
            self.backgroundColor = player1Color;
            self.layer.borderColor = [UIColor blackColor].CGColor;
            break;
        case GONE:
            self.backgroundColor = [UIColor blackColor];
            self.layer.borderColor = [UIColor blackColor].CGColor;
            break;
        case OCCUPIED:
<<<<<<< HEAD
            [_view setHidden:NO];
            _view.backgroundColor = player1Color;
=======
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            int w = self.bounds.size.width/cell.occupants.count;
            int h = self.bounds.size.height/cell.occupants.count;
            for(int i=0; i < cell.occupants.count; ++i)
            {
                Player* player = _grid.Players[cell.occupants[i]];
                UIView* block = [[UIView alloc] initWithFrame:
                                  CGRectMake(w*i, h*i, w, h)];
                
                block.backgroundColor=player.Color;
                block.layer.borderColor = [UIColor grayColor].CGColor;
                [self addSubview:block];
            }
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
            break;

    }
}

-(void) showMP{
    int diff = [CoordPoint distanceFrom:_cell To:_grid.MyPlayer.Location];
    _cost.text = [NSString stringWithFormat:@"%d", diff];

<<<<<<< HEAD
    }
    else
    {
        _cost.text = @"";
    }
=======
    _cost.textColor = [_grid.MyPlayer checkDistance:_cell] ?
                        [UIColor blackColor] : [UIColor redColor];
    
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
}

-(void) showBP{
    int diff = [CoordPoint distanceFrom:_cell To:_grid.MyPlayer.Location];
    _cost.text = [NSString stringWithFormat:@"%d", diff];
    
    _cost.textColor = [_grid.MyPlayer checkDistance:_cell] ?
    [UIColor blackColor] : [UIColor redColor];
    
<<<<<<< HEAD
    if(cell.bombCost)
    {
        _cost.text = [NSString stringWithFormat:@"%d",cell.bombCost];
        _cost.textColor = player1Color;
    }
    else
    {
        _cost.text = @"";
    }
=======
>>>>>>> 9eca385274a4ad10699a6e4ccce5b4b391b163ae
}

@end
