//
//  CoordPoint.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/8/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "CoordPoint.h"

@implementation CoordPoint

@synthesize x=_x, y=_y;


-(NSArray*) arrayFromCoord
{
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:_x],
                                     [NSNumber numberWithInt:_y],
                                      nil];
}


-(id) initWithX:(int)initX andY:(int)initY
{
    if([super init])
    {
        _x = initX;
        _y = initY;
    }
    
    return self;
}


+(id) coordWithX:(int)x andY:(int)y
{
    return [[self alloc] initWithX:x andY:y];
}


+(id) coordWithArray:(NSArray *)array
{
    return [[self alloc] initWithX:[array[0] intValue] andY:[array[1] intValue]];
}


+(int) distanceFrom:(CoordPoint *)p1 To:(CoordPoint *)p2
{
    
    int xDiff = abs(p1.x - p2.x);
    int yDiff = abs(p1.y - p2.y);
    
    return xDiff + yDiff;
}

@end
