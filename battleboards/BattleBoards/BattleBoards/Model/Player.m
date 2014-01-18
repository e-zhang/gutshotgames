//
//  Player.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "Player.h"
#import "DBDefs.h"

@implementation Player

@synthesize Points=_remainingPoints;
@synthesize Alive;
@synthesize Bombs=_bombs;
@synthesize Move=_move;
@synthesize Location=_location;
@synthesize Id=_userId;
@synthesize Name=_name;
@synthesize Color=_playerColor;
@synthesize GameId=_gameId;

-(id) initWithProperties:(NSDictionary *)props
               withColor:(UIColor *)color
               withGameId:(int)gameId
               andPoints:(int)points
{
    if([super init])
    {
        _name = props[DB_USER_NAME];
        _userId = props[DB_USER_ID];
        _move = [CoordPoint coordWithArray:props[DB_START_LOC]];
        _points = points;
        _remainingPoints = points;
        _updated = NO;
        _gameId = gameId;
        _playerColor = color;
        [self reset];
    }
    
    return self;
}


-(void) reset
{
    _location = _move;
    _move = nil;
    [_bombs removeAllObjects];
    _points = _remainingPoints;
    _updated = NO;
}

-(void) cancel
{
    _move = nil;
    [_bombs removeAllObjects];
    [self willChangeValueForKey:@"Points"];
    _remainingPoints = _points;
    [self didChangeValueForKey:@"Points"];
}


-(BOOL) addMove:(CellValue*)move
{
    if(![self checkDistance:move]) return NO;
    
    _move = [move.coord copy];
    return YES;
}


-(BOOL) addBomb:(CellValue*)bomb
{
    if(![self checkDistance:bomb]) return NO;
    
    [_bombs addObject:bomb.coord];
    
    return YES;
}


-(BOOL) updateMove:(CoordPoint *)move Bombs:(NSArray *)bombs andPoints:(int) points
{
    BOOL hasUpdate = _updated;
    
    // cancel previous update, and apply new one
    [self cancel];
    if(move)
    {
        _move = move;
    }
    
    [_bombs addObjectsFromArray:bombs];
    
    _remainingPoints = points;
    
    _updated = YES;
    return hasUpdate;
}


-(BOOL) checkDistance:(CellValue*)dest
{
    if(_points < dest.cost) return NO;

    [self willChangeValueForKey:@"Points"];
    _remainingPoints -= dest.cost;
    [self didChangeValueForKey:@"Points"];
    return YES;
}


-(void) getPointsFromBomb:(int)points
{
   _points += points;
   _remainingPoints += points;
}

@end
