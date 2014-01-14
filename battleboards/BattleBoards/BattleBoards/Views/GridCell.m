//
//  GridCell.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GridCell.h"
#import <QuartzCore/QuartzCore.h>
#include "CharColors.h"

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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CellValue* cellV = [_grid getCellAtRow:_cell.x andCol:_cell.y];
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
        case OCCUPIED:
        {
            NSLog(@"occupied-occupants-%@",cellV.occupants);
            if([cellV.occupants containsObject:_grid.myPlayerId])
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
    CellValue* cell = [_grid getCellAtRow:_cell.x andCol:_cell.y];

    NSLog(@"update-called-%d%d-%d",_cell.x,_cell.y,cell.state);
    
    switch(cell.state)
    {
        case EMPTY:
        case INIT:
        {
            NSLog(@"removeView4321");
            [_view setHidden:YES];
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
            [_view setHidden:NO];
            _view.backgroundColor = player1Color;
            break;
    }
}

-(void) showMP{
    CellValue* cell = [_grid getCellAtRow:_cell.x andCol:_cell.y];
    
    if(cell.moveCost)
    {
        _cost.text = [NSString stringWithFormat:@"%d",cell.moveCost];
        _cost.textColor = [UIColor blackColor];

    }
    else
    {
        _cost.text = @"";
    }
}

-(void) showBP{
    CellValue* cell = [_grid getCellAtRow:_cell.x andCol:_cell.y];
    
    if(cell.bombCost)
    {
        _cost.text = [NSString stringWithFormat:@"%d",cell.bombCost];
        _cost.textColor = player1Color;
    }
    else
    {
        _cost.text = @"";
    }
}

@end
