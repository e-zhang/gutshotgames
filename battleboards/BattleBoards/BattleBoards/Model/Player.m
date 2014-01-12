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

-(id) initWithProperties:(NSDictionary *)props andPoints:(int)points
{
    if([super init])
    {
        _name = props[DB_USER_NAME];
        _userId = props[DB_USER_ID];
       // _move = [CoordPoint coordWithArray:props[DB_START_LOC]];
        _points = points;
        _remainingPoints = points;
        _updated = NO;
        [self reset];
        
        NSLog(@"initializing-%@",_name);
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
    _remainingPoints = _points;
}

//we need to add a different initial set because the interface is different. Click and place vs. click and drag.
-(BOOL) setInitialPos:(CoordPoint *)pos{
    _move = pos;
    _location = _move;
    return YES;
}

-(BOOL) addMove:(CoordPoint *)move
{
    if(![self checkDistance:move]) return NO;
    
    _move = move;
    return YES;
}


-(BOOL) addBomb:(CoordPoint *)bomb
{
    if(![self checkDistance:bomb]) return NO;
    
    [_bombs addObject:bomb];
    
    return YES;
}


-(BOOL) updateMove:(CoordPoint *)move andBombs:(NSArray *)bombs
{
    BOOL hasUpdate = _updated;
    
    // cancel previous update, and apply new one
    [self cancel];
    if(move)
    {
        BOOL check = [self addMove:move];
        NSAssert(check, @"move update from database has invalid move");
    }
    
    for(CoordPoint* b in bombs)
    {
        BOOL check = [self addBomb:b];
        NSAssert(check, @"bomb update from database has invalid bomb");
    }
    
    _updated = YES;
    return hasUpdate;
}


-(BOOL) checkDistance:(CoordPoint *)dest
{
    // check to see if player has enough points for distance;
    int distance = [CoordPoint distanceFrom:dest To:_location];
    NSLog(@"checking d-%d-%d",distance,_points);
    
    //if(_points < distance) return NO;
    
    _remainingPoints -= distance;
    
    return YES;
}


-(void) getPointsFromBomb:(int)points
{
    _points += points;
    _remainingPoints += points;
}

@end
