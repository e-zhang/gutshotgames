//
//  Player.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "Player.h"

@implementation Player

-(id) initWithStart:(CoordPoint *)start andPoints:(int)points
{
    if([super init])
    {
<<<<<<< HEAD
        _name = props[DB_USER_NAME];
        _userId = props[DB_USER_ID];
       // _move = [CoordPoint coordWithArray:props[DB_START_LOC]];
=======
        _move = start;
>>>>>>> 5ff438ca72e1e36df958fb0ab557aeb8682d4480
        _points = points;
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


-(BOOL) checkDistance:(CoordPoint *)dest
{
    // check to see if player has enough points for distance;
    
    int xDiff = abs(dest.x - _location.x);
    int yDiff = abs(dest.y - _location.y);
    
    
<<<<<<< HEAD
    _updated = YES;
    return hasUpdate;
}


-(BOOL) checkDistance:(CoordPoint *)dest
{
    // check to see if player has enough points for distance;
    int distance = [CoordPoint distanceFrom:dest To:_location];
    NSLog(@"checking d-%d-%d",distance,_points);
=======
    int distance = xDiff + yDiff;
>>>>>>> 5ff438ca72e1e36df958fb0ab557aeb8682d4480
    
    //if(_points < distance) return NO;
    
    _points -= distance;
    
    return YES;
}

@end
