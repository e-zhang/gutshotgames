//
//  CoordPoint.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/8/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordPoint : NSObject
@property int x;
@property int y;


-(id) initWithX:(int)initX andY:(int)initY;

+(id) coordWithX:(int)x andY:(int)y;
@end

