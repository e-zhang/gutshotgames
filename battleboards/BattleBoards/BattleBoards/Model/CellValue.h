//
//  CellTypes.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//


typedef enum CellStates
{
    INIT = -1,
    EMPTY = 0,
    BOMB = 1,
    OCCUPIED = 2,
    GONE = 3
} CellStates;


@interface CellValue : NSObject

@property CellStates state;
@property NSMutableArray* occupants;
@property NSMutableArray* bombers;

@property NSInteger moveCost;
@property NSInteger bombCost;

-(void)insertOccupant:(NSString*)occupant;
-(void)insertBomb:(NSString*)bomb;

@end