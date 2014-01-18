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
    CoordPoint* _cell;
    GridModel* _grid;
    
    UILabel *_cost;
}


-(id) initWithFrame:(CGRect)frame andGrid:(GridModel*)grid andCoord:(CoordPoint*)coord;

-(void) update;
-(void) showCost;



@end
