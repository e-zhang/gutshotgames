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

    circle.layer.cornerRadius = (self.frame.size.width - 10.0f) / 2;
    [self addSubview:circle];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    

    CellValue* cellV = [_grid getCellAtRow:_cell.x andCol:_cell.y];
    NSLog(@"displayCellState-%d%d--%d",_cell.x,_cell.y,cellV.state);
    
    switch (cellV.state)
    {
        case OCCUPIED:
        {
            NSLog(@"occupied-occupants-%@",cellV.occupants);
            if([_cell isEqual:_grid.MyPlayer.Location])
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
}

-(void) update
{

    CellValue* cell = [_grid getCellAtRow:_cell.x andCol:_cell.y];
    switch(cell.state)
    {
        case EMPTY:
        {
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
            break;

    }
}

-(void) showMP{
    int diff = [CoordPoint distanceFrom:_cell To:_grid.MyPlayer.Location];
    _cost.text = [NSString stringWithFormat:@"%d", diff];

    _cost.textColor = [_grid.MyPlayer checkDistance:_cell] ?
                        [UIColor blackColor] : [UIColor redColor];
    
}

-(void) showBP{
    int diff = [CoordPoint distanceFrom:_cell To:_grid.MyPlayer.Location];
    _cost.text = [NSString stringWithFormat:@"%d", diff];
    
    _cost.textColor = [_grid.MyPlayer checkDistance:_cell] ?
    [UIColor blackColor] : [UIColor redColor];
    
}

@end
