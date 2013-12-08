//
//  GridCell.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridModel.h"

@interface GridCell : UIView
{
    GridModel* _grid;
}

-(id) initWithFrame:(CGRect)frame andGrid:(GridModel*)grid;

-(void) update;

@end
