//
//  GridView.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GridView.h"
#import "CoordPoint.h"

@implementation GridView

- (id)initWithFrame:(CGRect)frame withSize:(int)size andGridModel:(GridModel *)grid;
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _size = size;
        float width = frame.size.width / _size;
        float height = frame.size.height / _size;
        for(int r = 0; r < _size; ++r)
        {
            for(int c = 0; c < _size; ++c)
            {
                GridCell* cell = [[GridCell alloc] initWithFrame:CGRectMake(c * height, r * width, width, height)
                                                         andGrid:grid
                                                        andCoord:[CoordPoint coordWithX:r andY:c]];
                cell.tag = (r+1)*_size + (c+1);
                NSLog(@"cell.tag-%ld",(long)cell.tag);
                [self addSubview:cell];
            }
        }
    }
    return self;
}

-(void) updateCell:(CoordPoint *)cell
{
    int tag = (cell.x+1)*_size + (cell.y+1);
    GridCell* gridCell = (GridCell*)[self viewWithTag:tag];
    NSLog(@"gridview cellupdate-%@",gridCell);
    [gridCell update];
}

-(void)startNR{
    NSLog(@"startNR");
    for(int r = 0; r < _size; ++r)
    {
        for(int c = 0; c < _size; ++c)
        {
            int tag = (r+1)*_size + (c+1);
            GridCell* gridCell = (GridCell*)[self viewWithTag:tag];
            [gridCell update];
        }
    }

}

-(void)showMoveP{

    NSLog(@"show da moves");
    for(int r = 0; r < _size; ++r)
    {
        for(int c = 0; c < _size; ++c)
        {
            int tag = (r+1)*_size + (c+1);
            GridCell* gridCell = (GridCell*)[self viewWithTag:tag];
            [gridCell showMP];
        }
    }
}

-(void)showBombP{
    
    NSLog(@"show da bombs");
    for(int r = 0; r < _size; ++r)
    {
        for(int c = 0; c < _size; ++c)
        {
            int tag = (r+1)*_size + (c+1);
            GridCell* gridCell = (GridCell*)[self viewWithTag:tag];
            [gridCell showBP];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{ow
    // Drawing code
}
*/

@end
