//
//  Player.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordPoint.h"

@interface Player : NSObject
{
    CoordPoint* _location;
    int _points;
    CoordPoint* _move;
    NSMutableArray* _bombs;
}

-(id) initWithStart:(CoordPoint*)start andPoints:(int)points;

-(BOOL) addMove:(CoordPoint*) move;
-(BOOL) addBomb:(CoordPoint*) bomb;
-(void) reset;

-(BOOL) checkDistance:(CoordPoint*) dest;


@end
