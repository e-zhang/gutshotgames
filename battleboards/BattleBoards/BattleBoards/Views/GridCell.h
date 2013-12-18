//
//  GridCell.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridModel.h"

@protocol GridCellDelegate <NSObject>
- (void)cellTouched:(CoordPoint*)coord;
@end

@interface GridCell : UIView
{
    GridModel* _grid;
    CoordPoint* _cell;
}

@property (strong, nonatomic) id <GridCellDelegate> delegate;

-(id) initWithFrame:(CGRect)frame andGrid:(GridModel*)grid andCoord:(CoordPoint*)coord;

-(void) update;

@end
