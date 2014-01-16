//
//  CellValue.m
//  BattleBoards
//
//  Created by Eric Zhang on 1/2/14.
//  Copyright (c) 2014 GutShotGames. All rights reserved.
//

#import "CellValue.h"

@implementation CellValue

-(id) init
{
    if([super init])
    {
        self.state = EMPTY;
        self.occupants = [[NSMutableArray alloc] init];
        self.bombers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
