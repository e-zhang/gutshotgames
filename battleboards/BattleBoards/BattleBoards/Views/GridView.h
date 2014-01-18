//
//  GridView.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GridModel.h"

@protocol GridViewDelegate <NSObject>
@end

@interface GridView : UIView<UIGestureRecognizerDelegate>
{
    GridModel* _grid;
}


-(void) updateCell:(CoordPoint*)cell;
-(void) refreshCosts;

- (id)initWithFrame:(CGRect)frame andGridModel:(GridModel *)grid;

@end
