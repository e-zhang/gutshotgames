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
    NSString* _name;
    NSString* _userId;
    
    CoordPoint* _location;
    int _points;
    int _remainingPoints;
    CoordPoint* _move;
    NSMutableArray* _bombs;
    UIColor* _playerColor;
    BOOL _updated;
}

-(id) initWithProperties:(NSDictionary*)props
               withColor:(UIColor*)color
               andPoints:(int)points;

// for updating user inputs
-(BOOL) addMove:(CoordPoint*) move;
-(BOOL) addBomb:(CoordPoint*) bomb;
// for updating from database
-(BOOL) updateMove:(CoordPoint*)move andBombs:(NSArray*)bombs;
-(void) reset;
-(void) cancel;

-(BOOL) checkDistance:(CoordPoint*) dest;

-(void) getPointsFromBomb:(int) points;

@property (readwrite) int Points;
@property (readwrite) BOOL Alive;
@property (readonly) NSArray* Bombs;
@property (readonly) CoordPoint* Move;
@property (readonly) CoordPoint* Location;
@property (readonly) NSString* Name;
@property (readonly) NSString* Id;
@property (readonly) UIColor* Color;

@end
