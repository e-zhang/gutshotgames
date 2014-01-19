//
//  CellValue.m
//  BattleBoards
//
//  Created by Eric Zhang on 1/2/14.
//  Copyright (c) 2014 GutShotGames. All rights reserved.
//

#import "CellValue.h"


@interface CellValue()

@property (readwrite) CoordPoint* coord;

@end

@implementation CellValue

-(id) initWithCoord:(CoordPoint *)coord
{
    if([super init])
    {
        self.coord = coord;
        self.state = EMPTY;
        self.occupants = [[NSMutableArray alloc] init];
        self.bombers = [[NSMutableArray alloc] init];
        self.cost = 0;
    }
    
    return self;
}

@end
