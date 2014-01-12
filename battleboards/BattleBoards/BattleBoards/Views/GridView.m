//
//  GridView.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GridView.h"
#import "CoordPoint.h"
#import "GridModel.h"

@implementation GridView

- (id)initWithFrame:(CGRect)frame andGridSize:(int)size
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _grid = [[GridModel alloc] initWithSize:size];
        //_grid.delegate = self;
        float width = frame.size.width / size;
        float height = frame.size.height / size;
        for(int r = 0; r < size; ++r)
        {
            for(int c = 0; c < size; ++c)
            {
<<<<<<< HEAD
                GridCell* cell = [[GridCell alloc] initWithFrame:CGRectMake(c * height, r * width, width, height)
                                                         andGrid:grid
                                                        andCoord:[CoordPoint coordWithX:r andY:c]];
                cell.tag = (r+1)*_size + (c+1);
                NSLog(@"cell.tag-%ld",(long)cell.tag);
=======
                
                CoordPoint* cp = [[CoordPoint alloc] initWithX:r andY:c];
                
                GridCell* cell = [[GridCell alloc] initWithFrame:CGRectMake(c * width, r * height, width, height) andGrid:_grid andCoord:cp];
                cell.delegate = self;
>>>>>>> 5ff438ca72e1e36df958fb0ab557aeb8682d4480
                [self addSubview:cell];
            }
        }
    }
    return self;
}

<<<<<<< HEAD
-(void) updateCell:(CoordPoint *)cell
{
    int tag = (cell.x+1)*_size + (cell.y+1);
    GridCell* gridCell = (GridCell*)[self viewWithTag:tag];
=======
- (void)cellTouched:(CoordPoint *)coord{
>>>>>>> 5ff438ca72e1e36df958fb0ab557aeb8682d4480
    
}

-(void)startNR{
 
}

-(void)showMoveP{

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
