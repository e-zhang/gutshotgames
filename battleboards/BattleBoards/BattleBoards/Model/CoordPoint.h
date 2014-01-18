//
//  CoordPoint.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/8/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordPoint : NSObject
{
    int _x;
    int _y;
}

@property (readonly) int x;
@property (readonly) int y;


-(NSArray*) arrayFromCoord;

-(id) initWithX:(int)initX andY:(int)initY;

-(BOOL) isEqual:(id)object;

-(NSArray*) getSurroundingCoord;

+(id) coordWithX:(int)x andY:(int)y;
+(id) coordWithArray:(NSArray*) array;
+(int) distanceFrom:(CoordPoint*)p1 To:(CoordPoint*)p2;
@end

