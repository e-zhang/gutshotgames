//
//  Player.h
//  BattleBoards
//
//  Created by Eric Zhang on 1/29/14.
//  Copyright (c) 2014 GutShotGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Unit.h"

// defs for undo array
#define COORD_IDX 0
#define COST_IDX 1
#define STATE_IDX 2
#define UNIT_IDX 3


@interface Player : NSObject
{
    NSString* _name;
    NSString* _userId;
    NSString* _fbId;

    NSMutableArray* _bombs;
    NSMutableArray* _units;
    int _selectedUnit;
    int _points;
    
    BOOL _updated;
    
    NSMutableArray* _lastPlays;
}

-(id) initWithProperties:(NSDictionary*)props
               andPoints:(int)points;


-(NSDictionary*) getInfoForDB;

-(BOOL) updateWithUnits:(NSDictionary*)units andPoints:(int)points;

-(void) addRoundBonus:(int) bonus;
-(void) setSelected:(int) selected;

// for updating user inputs
-(BOOL) addMove:(CellValue*) move;
-(BOOL) addBomb:(CellValue*) bomb;
-(void) addUnits:(NSArray*) units;
-(NSArray*) removeUnit:(CoordPoint*)loc;


-(NSArray*) undoLastPlay;
-(void) undoMove:(CoordPoint*)move forUnit:(int)unit;
-(void) undoBomb:(CoordPoint*)bomb;

-(BOOL) checkDistance:(CellValue*) dest forMove:(BOOL)move;

@property (readonly) NSString* Name;
@property (readonly) NSString* FacebookId;
@property (readonly) NSString* Id;

@property (readonly) NSArray* Units;
@property (readonly) Unit* SelectedUnit;

@property (readonly) NSArray* Bombs;
@property (readonly) int Points;
@property (readonly) int GameId;
@property (readonly) BOOL Alive;

@property (readonly) BOOL Updated;

@end
