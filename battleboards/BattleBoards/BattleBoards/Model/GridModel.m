//
//  GridModel.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GridModel.h"


@implementation GridModel


-(id) initWithGame:(GameInfo *)game andPlayer:(NSString *)player
{

    if([super init])
    {
        _gameInfo = game;
        _myPlayerId = player;
        int size = [game.gridSize intValue];
        NSAssert(size < GONE && size > EMPTY, @"Invalid size of grid %d", size);
        
        NSMutableArray* grid = [NSMutableArray arrayWithCapacity:size];
        for(int i = 0; i < size; ++i)
        {
            NSMutableArray* row = [NSMutableArray arrayWithCapacity:size];
            for(int i = 0; i < size; ++i)
            {
                CellValue* cell = [[CellValue alloc] init];
                cell.state = EMPTY;
                [row addObject:cell];
            }
            [grid addObject:row];
        }
        _grid = grid;
    }
    
    return self;
}


-(CellValue*) getCellAtRow:(int)row andCol:(int)col
{
    return _grid[row][col];
}


-(void) addMove:(CoordPoint *)move byPlayer:(NSString *)player
{
    
}

-(void) addBombs:(NSArray*)bombs byPlayer:(NSString *)player
{
    
}

@end
