//
//  GridCell.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GridCell.h"
#import "CellStates.h"
#import <QuartzCore/QuartzCore.h>
#include "CharColors.h"

static const int SELF = 1;

@implementation GridCell

- (id)initWithFrame:(CGRect)frame andGrid:(GridModel *)grid andCoord:(CoordPoint *)coord
{
    self = [super initWithFrame:frame];
    if (self) {

        _grid = grid;
        _cell = coord;
        
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0f;
        
        _cost = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f,self.frame.size.width, self.frame.size.height)];
        _cost.textAlignment = NSTextAlignmentCenter;
        _cost.textColor = [UIColor blackColor];
        _cost.text = @"";
        
        [self addSubview:_cost];
    }
    return self;
}

- (void)drawMyDot
{
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, self.frame.size.width - 10.0f, self.frame.size.height - 10.0f)];
    circle.tag = SELF;
    circle.backgroundColor = player1Color;
    circle.layer.cornerRadius = (self.frame.size.width - 10.0f) / 2;
    [self addSubview:circle];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
<<<<<<< HEAD
    CellValue* cellV = [_grid getCellAtRow:_cell.x andCol:_cell.y];
    NSLog(@"displayCellState-%d%d--%d-%d",_cell.x,_cell.y,cellV.state,cellV.moveCost);
    
    switch (cellV.state)
    {
        case INIT:
        {
            [_grid makeAllInit];
            [_grid initailizePositionatRow:_cell.x andCol:_cell.y];
            [self drawMyDot];
            break;
        }
        case OCCUPIED:
        {
            NSLog(@"occupied-occupants-%@",cellV.occupants);
            if([cellV.occupants containsObject:_grid.myPlayerId])
            {
                NSLog(@"thats me");
                UITouch *touch = [[event allTouches] anyObject];
                CGPoint touchLocation = [touch locationInView:self];
                //drag
                dragging = YES;
                oldX = touchLocation.x;
                oldY = touchLocation.y;
            }
            break;
        }
        case BOMB:
            break;
        case EMPTY:
            break;
        case GONE:
            break;
        default:
            break;
    }
    
    /*if(cellV.state==OCCUPIED && [cellV.occupants containsObject:_grid.myPlayerId])
    {
        //drag self to new block
        //display possibilities
        positionChange = YES;
    }
    else if(cellV.state==BOMB)
    {
        //cant do anything on this square
    }
    else
    {
        //try and place bomb.. check if pts allow, if so update
    }*/
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch ended");
    
    if(positionChange)
    {
        //move player
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
=======
    id state = [_grid getStateForRow:_cell.x andCol:_cell.y];

    if([state integerValue] == -1)
        [_delegate cellTouched:_cell];
>>>>>>> 5ff438ca72e1e36df958fb0ab557aeb8682d4480
}

-(void) update
{
<<<<<<< HEAD
    CellValue* cell = [_grid getCellAtRow:_cell.x andCol:_cell.y];

  //  NSLog(@"called-%d",cell.state);
=======
    id state = [_grid getStateForRow:_cell.x andCol:_cell.y];
>>>>>>> 5ff438ca72e1e36df958fb0ab557aeb8682d4480
    
    if([state isKindOfClass:[NSString class]])
    {
        switch([state intValue])
        {
            case EMPTY:
                self.layer.borderColor = [UIColor blackColor].CGColor;
                self.backgroundColor = [UIColor whiteColor];
                break;
            case BOMB:
                self.backgroundColor = [UIColor grayColor];
                self.layer.borderColor = [UIColor redColor].CGColor;
                break;
            case GONE:
                self.backgroundColor = [UIColor blackColor];
                self.layer.borderColor = [UIColor blackColor].CGColor;
                break;
        }
    }
    else if([state isKindOfClass:[NSNumber class]])
    {
        // player numbers
    }
    else if([state isKindOfClass:[NSArray class]])
    {
        // todo: evaluate all occurances on the square
    }
    else
    {
<<<<<<< HEAD
        case EMPTY:
        case INIT:
        {
            UIView *view = [self viewWithTag:SELF];
            [view removeFromSuperview];
            self.layer.borderColor = [UIColor blackColor].CGColor;
            self.backgroundColor = [UIColor whiteColor];
            break;
        }
        case BOMB:
            self.backgroundColor = [UIColor grayColor];
            self.layer.borderColor = [UIColor redColor].CGColor;
            break;
        case GONE:
            self.backgroundColor = [UIColor blackColor];
            self.layer.borderColor = [UIColor blackColor].CGColor;
            break;
        case OCCUPIED:
            break;
=======
        NSAssert(NO, @"Received an invalid class for cell state: %@", [state class]);
>>>>>>> 5ff438ca72e1e36df958fb0ab557aeb8682d4480
    }
}

-(void) showMP{
    CellValue* cell = [_grid getCellAtRow:_cell.x andCol:_cell.y];
    
    if(cell.moveCost)
    {
        _cost.text = [NSString stringWithFormat:@"%d",cell.moveCost];
        _cost.textColor = [UIColor blackColor];

    }
}

-(void) showBP{
    CellValue* cell = [_grid getCellAtRow:_cell.x andCol:_cell.y];
    
    if(cell.bombCost)
    {
        _cost.text = [NSString stringWithFormat:@"%d",cell.bombCost];
        _cost.textColor = player1Color;
    }
}

@end
