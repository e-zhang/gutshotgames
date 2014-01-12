//
//  GridView.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridCell.h"

@protocol GridViewDelegate <NSObject>
@end

@interface GridView : UIView<GridCellDelegate>
{
    GridModel* _grid;
}

@property (strong, nonatomic) id <GridViewDelegate> delegate;

<<<<<<< HEAD
-(void) updateCell:(CoordPoint*)cell;
-(void) startNR;
-(void) showMoveP;
-(void) showBombP;
=======
-(id) initWithFrame:(CGRect) frame andGridSize:(int) size;
>>>>>>> 5ff438ca72e1e36df958fb0ab557aeb8682d4480

@end
