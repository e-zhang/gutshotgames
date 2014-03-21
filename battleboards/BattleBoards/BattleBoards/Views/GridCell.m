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
        _cost.opaque = NO;
        _cost.backgroundColor = [UIColor clearColor];

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
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.backgroundColor = [UIColor clearColor];
            break;
        }
        case BOMB:
        case GONE:
        {
            [self drawBombsForCell:cell];
        }
        case OCCUPIED:
        {
            [self drawOccupantsForCell:cell];
            break;
        }
    }

    [self addSubview:_cost];
    [self showCost:NO];
    [self bringSubviewToFront:_cost];
}

-(void) drawBombsForCell:(CellValue*)cell
{
    self.backgroundColor = [UIColor clearColor];
    int w = self.bounds.size.width/cell.bombers.count;
    int h = self.bounds.size.height;
    NSArray* bombers = [cell.bombers allObjects];
    for(int i=0; i < cell.bombers.count; ++i)
    {
        NSString* playerId = [[_grid decomposePlayerId:[bombers objectAtIndex:i]] firstObject];
        Player* player = [_grid.Players objectForKey:playerId];
        UIView* block = [[UIView alloc] initWithFrame:
                         CGRectMake(w/2*i, 0, w, h)];
        block.backgroundColor=_grid.CharColors[player.GameId];
        block.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:block];
    }
    
}


-(void) drawOccupantsForCell:(CellValue*)cell
{
    self.backgroundColor = [UIColor clearColor];
    int w = self.bounds.size.width;
    int h = self.bounds.size.height/cell.occupants.count;
    NSArray* occupants = cell.occupants.allObjects;
    for(int i=0; i < cell.occupants.count; ++i)
    {
        NSString* occupant = occupants[i];
        NSArray* ids = [_grid decomposePlayerId:occupant];
        NSString* playerId = [ids firstObject];
        int unitId = [[ids lastObject] intValue];
        
        Player* player = [_grid.Players objectForKey:playerId];
        
        BOOL drawUnit = player.Units.count == 0 || player.Units.count < unitId||
                        ((Unit*)player.Units[unitId]).Alive;
    
        CGRect frame = CGRectMake(w*0.5 - h*0.75/2, h*(i+0.25/2),
                                  h *0.75, h * 0.75);
        
        if(drawUnit)
        {
            UIView* block = [[UIView alloc] initWithFrame:frame];
            
            block.layer.cornerRadius = MIN((w*0.75)/2, (h*0.75)/2);
            
            block.backgroundColor=_grid.CharColors[player.GameId];
            block.layer.borderColor = [UIColor whiteColor].CGColor;
            [self addSubview:block];
        }
        else
        {
            UILabel* block = [[UILabel alloc] initWithFrame:frame];
            block.text = @"X";
            block.textAlignment = NSTextAlignmentCenter;
            [block.font fontWithSize:12];
            block.textColor = _grid.CharColors[player.GameId];
            block.backgroundColor = [UIColor clearColor];
            block.opaque = NO;
            [self addSubview:block];
        }

    }

}

-(void) showCost:(BOOL) showMoves
{
    int cost = 0;
    CellValue* cell = [_grid getCellWithCoord:_cell];

    if(!showMoves)
    {
        Player* player = _grid.MyPlayer;

        cost = cell.bombCost <= player.Points ? cell.bombCost : -1;
    }
    else
    {
        
        cost = cell.moveCost;
    }

    
    _cost.text = cost > 0 ? [NSString stringWithFormat:@"%d",cost] : @"";
}


@end
