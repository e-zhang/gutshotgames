//
//  CharacterViewController.h
//  sumosmash
//
//  Created by Eric Zhang on 4/17/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Character.h"
#import "MoveMenu.h"

@interface CharacterViewController : UIViewController<MoveMenuDelegate>
{
    Character* _character;
    
    UILabel* _characterDisplay;
    UIImage* _characterPic;
    UIPopoverController* _menuController;
    
    BOOL _isShowingMenu;
    BOOL _isSelf;
    
    SEL _submitMoveSelector;
    id _submitMoveTarget;
}

- (id) initWithId:(NSString*) targetId name:(NSString*)name selfId:(NSString*)selfId
       onMoveTarget:(id)target onMoveSelect:(SEL)selector;
- (void) setUserPic:(NSString*) path;


@property (readonly, nonatomic) UILabel* Display;
@property (readonly, nonatomic) Character* Char;

@end
