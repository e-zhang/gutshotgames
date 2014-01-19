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

        _cell = coord;
        _grid = grid;
        
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



-(void) update
{
    CellValue* cell = [_grid getCellWithCoord:_cell];

    NSLog(@"update-called-%d%d-%d",_cell.x,_cell.y,cell.state);
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    switch(cell.state)
    {
        case EMPTY:
        {
            self.layer.borderColor = [UIColor blackColor].CGColor;
            self.backgroundColor = [UIColor clearColor];
            [self addSubview:_cost];
            break;
        }
        case BOMB:
            self.backgroundColor = _grid.MyPlayer.Color;
            self.layer.borderColor = [UIColor blackColor].CGColor;
            break;
        case GONE:
            self.backgroundColor = [UIColor blackColor];
            self.layer.borderColor = [UIColor blackColor].CGColor;
            break;
        case OCCUPIED:
        {
            int w = self.bounds.size.width/cell.occupants.count;
            int h = self.bounds.size.height/cell.occupants.count;
            for(int i=0; i < cell.occupants.count; ++i)
            {
                Player* player = _grid.Players[cell.occupants[i]];
                UIView* block = [[UIView alloc] initWithFrame:
                                  CGRectMake(w*i, h*i, w, h)];
                block.layer.cornerRadius = MIN(w, h) / 2.0;
                block.backgroundColor=player.Color;
                block.layer.borderColor = [UIColor grayColor].CGColor;
                [self addSubview:block];
            }
            break;
        }

    }
    
    _cost.text = cell.cost > 0 ? [NSString stringWithFormat:@"%d", cell.cost] : @"";

}

-(void) showCost
{
    CellValue* cell = [_grid getCellWithCoord:_cell];
    _cost.text = cell.cost <= 0 ? @"" : [NSString stringWithFormat:@"%d",cell.cost];
}


@end
