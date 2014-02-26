//
//  Player.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "Unit.h"
#import "DBDefs.h"

@implementation Unit


@synthesize Alive;
@synthesize Move=_move;
@synthesize Location=_location;
@synthesize GameTag=_gameTag;

-(id) initWithStart:(CoordPoint *)loc
         withGameId:(int)gameId
{
    if([super init])
    {
        _move = loc;
        _updated = NO;
        _gameTag = gameId;
        self.Alive = YES;
        [self reset];
    }
    
    return self;
}


-(void) reset
{
    if(_move)
    {
        _location = _move;
        _move = nil;
    }

    _updated = NO;
}

-(void) addMove:(CellValue*)move
{
    _move = move.coord;
}

-(void) undoMove:(CoordPoint *)move
{
    if([move isEqual:_move])
    {
        _move = nil;
    }
}


-(void) updateMove:(CoordPoint *)move
{
    // cancel previous update, and apply new one
    _move = nil;
    
    if(move)
    {
        _move = move;
    }
}


@end
