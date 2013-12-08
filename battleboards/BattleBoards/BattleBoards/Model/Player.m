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
        _move = start;
        _points = points;
        [self reset];
    }
    
    return self;
}


-(void) reset
{
    _location = _move;
    _move = nil;
    [_bombs removeAllObjects];
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
    // check if straight vertical, horizontal, or diagonal;
    
    int xDiff = abs(dest.x - _location.x);
    int yDiff = abs(dest.y - _location.y);
    
    // check to see if valid move
    if(xDiff != 0 && yDiff != 0 && xDiff != yDiff)
    {
        return NO;
    }
    
    int distance = MAX(xDiff, yDiff);
    
    if(_points < distance) return NO;
    
    _points -= distance;
    
    return YES;
}

@end
