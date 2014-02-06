//
//  Player.h
//  BattleBoards
//
//  Created by Eric Zhang on 1/29/14.
//  Copyright (c) 2014 GutShotGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Unit.h"



@interface Player : NSObject
{
    NSString* _name;
    NSString* _userId;
    
    NSMutableArray* _units;
    int _selectedUnit;
    int _points;
    
    NSMutableArray* _lastPlays;
}

-(id) initWithProperties:(NSDictionary*)props
               andPoints:(int)points;


-(NSArray*) getUnitsForDB;

-(void) updateWithUnits:(NSArray*)units andPoints:(int)points;

-(void) addRoundBonus:(int) bonus;
-(void) setSelected:(int) selected;


// for updating user inputs
-(BOOL) addMove:(CellValue*) move;
-(BOOL) addBomb:(CellValue*) bomb;
-(void) addUnits:(NSArray*) units;
-(CoordPoint*) undoLastPlay;

-(BOOL) checkDistance:(CellValue*) dest;


@property (readonly) NSString* Name;
@property (readonly) NSString* Id;

@property (readonly) NSArray* Units;

@property (readonly) Unit* SelectedUnit;

@property (readonly) int Points;
@property (readonly) int GameId;
@property (readonly) BOOL Alive;

@end
