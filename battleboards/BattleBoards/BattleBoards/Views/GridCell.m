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
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0f;
        
        _cost = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f,self.frame.size.width, self.frame.size.height)];
        _cost.textAlignment = NSTextAlignmentCenter;
        _cost.textColor = [UIColor whiteColor];
        _cost.font = [UIFont fontWithName:@"GillSans" size:14.0f];
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
            self.backgroundColor = [UIColor clearColor];
            int w = self.bounds.size.width/cell.occupants.count;
            int h = self.bounds.size.height/cell.occupants.count;
            for(int i=0; i < cell.occupants.count; ++i)
            {
                Player* player = _grid.Players[cell.occupants[i]];
                UIView* block = [[UIView alloc] initWithFrame:
                                  CGRectMake((w*0.75)/2*i + (w*0.25/2), (h*0.75)/2*i + (h*0.25/2), w *0.75, h * 0.75)];
                block.layer.cornerRadius = MIN((w*0.75)/2, (h*0.75)/2);
                block.backgroundColor=player.Color;
                block.layer.borderColor = [UIColor grayColor].CGColor;
                [self addSubview:block];
            }
            break;
        }

    }
    
    _cost.text = cell.cost > 0 ? [NSString stringWithFormat:@"%d", cell.cost] : @"";

}

-(void) showCost:(BOOL) showMoves
{
    int cost = 0;

    if(!showMoves)
    {
        Player* p = _grid.MyPlayer;
        int dist = [CoordPoint distanceFrom:p.Location To:_cell];
        cost = dist <= p.Points ? dist : -1;
    }
    else
    {
        
        CellValue* cell = [_grid getCellWithCoord:_cell];
        cost = cell.cost;
    }

    
    _cost.text = cost > 0 ? [NSString stringWithFormat:@"%d",cost] : @"";
}


@end
