//
//  GridCell.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GridCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation GridCell

- (id)initWithFrame:(CGRect)frame andGrid:(GridModel *)grid andCoord:(CoordPoint *)coord
{
    NSLog(@"corez");
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"should be called?");
        // Initialization code
        _grid = grid;
        _cell = coord;
        
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0f;
        
      //  [self update];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CellValue* cellV = [_grid getCellAtRow:_cell.x andCol:_cell.y];
    NSLog(@"displayCellState-%d",cellV.state);
    
    switch (cellV.state)
    {
        case INIT:
            self.backgroundColor = [UIColor blueColor];
            [_grid initailizePositionatRow:_cell.x andCol:_cell.y];
            break;
        case OCCUPIED:
            break;
        case BOMB:
            break;
        case EMPTY:
            break;
        case GONE:
            break;
        default:
            break;
    }
    
    if(cellV.state==OCCUPIED && [cellV.occupants containsObject:_grid.myPlayerId])
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
    }
    
    
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

    NSLog(@"called-%d",cell.state);
    
    switch(cell.state)
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
        case OCCUPIED:
            break;
    }
}

-(void) displayMovePossibilities
{}

-(void) displayBombPossibilities
{}


@end
