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
    int _size;
}

@property (strong, nonatomic) id <GridViewDelegate> delegate;


-(void) updateCell:(CoordPoint*)cell;
-(void) startNR;
-(void) showMoveP;
-(void) showBombP;

- (id)initWithFrame:(CGRect)frame withGridModel:(GridModel *)grid;


@end
