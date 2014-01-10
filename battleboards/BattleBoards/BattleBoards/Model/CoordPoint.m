//
//  CoordPoint.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/8/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "CoordPoint.h"

@implementation CoordPoint

@synthesize x, y;


-(id) initWithX:(int)initX andY:(int)initY
{
    if([super init])
    {
        self.x = initX;
        self.y = initY;
    }
    
    return self;
}


+(id) coordWithX:(int)x andY:(int)y
{
    return [[self alloc] initWithX:x andY:y];
}

@end
