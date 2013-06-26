//
//  InvitationsViewController.h
//  sumosmash
//
//  Created by Eric Zhang on 4/29/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameInvitations.h"

@interface InvitationsViewController : UIViewController<UICollectionViewDataSource,
                                                        InvitationUpdateDelegate>
{
    id _target;
    SEL _selector;
    GameInvitations* _invites;
}

-(id) initWithFrame:(CGRect)frame invitations:(GameInvitations*) invites
             target:(id) target selector:(SEL) selector;


@end
