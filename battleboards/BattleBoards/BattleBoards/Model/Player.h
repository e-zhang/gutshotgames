//
//  Player.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{
    int x;
    int y;
} CoordPoint;


@interface Player : NSObject
{
    CoordPoint _location;
    int _points;
    CoordPoint _move;
    NSMutableArray* _bombs;
}


-(BOOL) addMove:(CoordPoint) move;
-(BOOL) addBomb:(CoordPoint) bomb;



@end
