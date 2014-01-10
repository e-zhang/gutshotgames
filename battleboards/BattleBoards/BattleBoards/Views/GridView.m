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

- (id)initWithFrame:(CGRect)frame withSize:(int)size andGridModel:(GridModel *)grid;
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
<<<<<<< HEAD
        _grid = [[GridModel alloc] initWithSize:size];
        //_grid.delegate = self;
        float width = frame.size.width / size;
        float height = frame.size.height / size;
        for(int r = 0; r < size; ++r)
=======
        _size = size;
        float width = frame.size.width / _size;
        float height = frame.size.height / _size;
        for(int r = 0; r < _size; ++r)
>>>>>>> e8d49ca87bce1673d50e470fc5582460d192bc2e
        {
            for(int c = 0; c < _size; ++c)
            {
<<<<<<< HEAD
                
                CoordPoint* cp = [[CoordPoint alloc] initWithX:r andY:c];
                
                GridCell* cell = [[GridCell alloc] initWithFrame:CGRectMake(c * width, r * height, width, height) andGrid:_grid andCoord:cp];
                cell.delegate = self;
=======
                GridCell* cell = [[GridCell alloc] initWithFrame:CGRectMake(c * height, r * width, c, r)
                                                         andGrid:grid
                                                        andCoord:[CoordPoint coordWithX:r andY:c]];
                cell.tag = r*_size + c;
>>>>>>> e8d49ca87bce1673d50e470fc5582460d192bc2e
                [self addSubview:cell];
            }
        }
    }
    return self;
}

-(void) updateCell:(CoordPoint *)cell
{
    int tag = cell.x*_size + cell.y;
    GridCell* gridCell = (GridCell*)[self viewWithTag:tag];
    
<<<<<<< HEAD
=======
    [gridCell update];
>>>>>>> e8d49ca87bce1673d50e470fc5582460d192bc2e
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
