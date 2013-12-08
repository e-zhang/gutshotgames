//
//  GridModel.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GridModel.h"
#import "CellStates.h"

@implementation GridModel

@synthesize Players = _players;

-(id) initWithSize:(int) size
{
    NSAssert(size < GONE && size > EMPTY, @"Invalid size of grid %d", size);
    
    if([super init])
    {
        NSMutableArray* grid = [NSMutableArray arrayWithCapacity:size];
        for(int i = 0; i < size; ++i)
        {
            NSMutableArray* row = [NSMutableArray arrayWithCapacity:size];
            for(int i = 0; i < size; ++i)
            {
                [row addObject:[NSNumber numberWithInt: EMPTY]];
            }
            [grid addObject:row];
        }
        _grid = grid;
    }
    
    return self;
}


-(id) getStateForRow:(int)row andCol:(int)col
{
    return _grid[row][col];
}

-(void) setState:(id)state forRow:(int)row andCol:(int)col
{
    _grid[row][col] = state;
}

-(void) couchDocumentChanged:(CouchDocument *)doc
{
    
}

@end
