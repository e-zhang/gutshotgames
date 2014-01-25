//
//  Player.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellValue.h"

@interface Player : NSObject
{
    NSString* _name;
    NSString* _userId;
    
    CoordPoint* _location;
    int _points;
    int _remainingPoints;
    CoordPoint* _move;
    NSMutableArray* _bombs;
    int _gameId;
    UIColor* _playerColor;
    BOOL _updated;
}

-(id) initWithProperties:(NSDictionary*)props
               withColor:(UIColor*)color
              withGameId:(int)gameId
               andPoints:(int)points;

// for updating user inputs
-(BOOL) addMove:(CellValue*) move;
-(BOOL) addBomb:(CellValue*) bomb;

// for updating from database
-(BOOL) updateMove:(CoordPoint*)move Bombs:(NSArray*)bombs andPoints:(int)points;
-(void) reset;
-(void) cancel;

-(void) addRoundBonus:(int) points;

-(BOOL) checkDistance:(CellValue*) dest;

-(void) getPointsFromBomb:(int) points;

@property (readwrite) int Points;
@property (readwrite) BOOL Alive;
@property (readonly) NSArray* Bombs;
@property (readonly) CoordPoint* Move;
@property (readonly) CoordPoint* Location;
@property (readonly) NSString* Name;
@property (readonly) NSString* Id;
@property (readonly) UIColor* Color;
@property (readonly) int GameId;

@end
