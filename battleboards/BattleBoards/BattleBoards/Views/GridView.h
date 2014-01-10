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

-(id) initWithFrame:(CGRect) frame andGridSize:(int) size;

@end