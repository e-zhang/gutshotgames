//
//  CellTypes.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//


typedef enum CellStates
{
    EMPTY,
    BOMB,
    OCCUPIED,
    GONE
} CellStates;



@interface CellValue : NSObject

@property CellStates state;
@property NSMutableArray* occupants;
@property NSMutableArray* bombers;

@end