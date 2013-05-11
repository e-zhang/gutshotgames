//
//  MoveMenu.h
//  sumosmash
//
//  Created by Eric Zhang on 4/15/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Move.h"

@protocol MoveMenuDelegate<NSObject>

- (BOOL) selectedItemChanged:(Move*) move;

@end

@interface MoveMenu : UIControl
{
    id<MoveMenuDelegate> _delegate;
    NSString* _target;
    BOOL _isSelf;
    UIButton* _selectedMove;
    UIView* _container;
}

- (id) initWithFrame:(CGRect)frame andDelegate:(id<MoveMenuDelegate>)delegate forPlayer:(NSString*)playerId isSelf:(BOOL)isSelf;

- (void) moveSelected:(UIButton*)sender;

- (void) clearMove;

@end
