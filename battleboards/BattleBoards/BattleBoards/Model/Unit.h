//
//  Player.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellValue.h"

@interface Unit : NSObject
{
    CoordPoint* _location;
    CoordPoint* _move;
    NSMutableArray* _bombs;
    int _gameTag;
    BOOL _updated;
}

-(id) initWithStart:(CoordPoint*)loc
         withGameId:(int)gameId;

// for updating user inputs
-(void) addMove:(CellValue*) move;
-(void) undoMove:(CoordPoint*)move;
-(void) addBomb:(CellValue*) bomb;
-(void) undoBomb:(CoordPoint*)move;

-(void) setLocation:(CoordPoint*)coord;

// for updating from database
-(void) updateMove:(CoordPoint*)move Bombs:(NSArray*)bombs;
-(void) reset;


@property (readwrite) BOOL Alive;
@property (readonly) NSArray* Bombs;
@property (readonly) CoordPoint* Move;
@property (readonly) CoordPoint* Location;

@property (readonly) int GameTag;

@end
