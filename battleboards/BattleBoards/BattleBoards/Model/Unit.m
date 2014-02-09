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
@synthesize Bombs=_bombs;
@synthesize Move=_move;
@synthesize Location=_location;
@synthesize GameTag=_gameTag;

-(id) initWithStart:(CoordPoint *)loc
         withGameId:(int)gameId
{
    if([super init])
    {
        _move = loc;
        _bombs = [[NSMutableArray alloc] init];
        _updated = NO;
        _gameTag = gameId;
        self.Alive = NO;
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

    [_bombs removeAllObjects];
    _updated = NO;
}

-(void) addMove:(CellValue*)move
{
    _move = move.coord;

}


-(void) addBomb:(CellValue*)bomb
{
    [_bombs addObject:bomb.coord];
}


-(void) updateMove:(CoordPoint *)move Bombs:(NSArray *)bombs
{
    // cancel previous update, and apply new one
    _move = nil;
    [_bombs removeAllObjects];
    
    if(move)
    {
        _move = move;
    }
    
    [_bombs addObjectsFromArray:bombs];
}


@end
