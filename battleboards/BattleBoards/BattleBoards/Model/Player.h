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

<<<<<<< HEAD
// for updating user inputs
-(BOOL) setInitialPos:(CoordPoint *)pos;
=======
>>>>>>> 5ff438ca72e1e36df958fb0ab557aeb8682d4480
-(BOOL) addMove:(CoordPoint*) move;
-(BOOL) addBomb:(CoordPoint*) bomb;
-(void) reset;

-(BOOL) checkDistance:(CoordPoint*) dest;


@end
