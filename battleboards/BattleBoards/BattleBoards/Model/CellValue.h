//
//  CellTypes.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "CoordPoint.h"

typedef enum CellStates
{
    EMPTY,
    BOMB,
    OCCUPIED,
    GONE,
    
} CellStates;



@interface CellValue : NSObject

-(id) initWithCoord:(CoordPoint*) coord;

@property CellStates state;
@property NSMutableArray* occupants;
@property NSMutableArray* bombers;
@property int bombCost;
@property int moveCost;
@property (readonly) CoordPoint* coord;


@end