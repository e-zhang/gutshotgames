//
//  CellValue.m
//  BattleBoards
//
//  Created by Eric Zhang on 1/2/14.
//  Copyright (c) 2014 GutShotGames. All rights reserved.
//

#import "CellValue.h"

@implementation CellValue

-(void)insertOccupant:(NSString*)occupant{
    if(!self.occupants)
        self.occupants = [[NSMutableArray alloc] init];
    
    if(![self.occupants containsObject:occupant])
        [self.occupants addObject:occupant];
}

-(void)insertBomb:(NSString*)bomb{
    if(!self.bombers)
        self.bombers = [[NSMutableArray alloc] init];
    
    if(![self.bombers containsObject:bomb])
        [self.bombers addObject:bomb];
}

@end
