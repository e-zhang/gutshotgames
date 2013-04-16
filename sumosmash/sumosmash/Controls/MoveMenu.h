//
//  MoveMenu.h
//  sumosmash
//
//  Created by Eric Zhang on 4/15/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoveType.h"

@protocol MoveMenuProtocol <NSObject>

- (void) selectedItemChanged:(MoveType) move;

@end

@interface MoveMenu : UIControl
{
    id<MoveMenuProtocol> _delegate;
    UIView* _container;
}

- (id) initWithFrame:(CGRect)frame andDelegate:(id<MoveMenuProtocol>)delegate forPlayer:(NSString*)playerId isSelf:(BOOL)isSelf;

@end
