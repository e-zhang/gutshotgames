//
//  FeedCell.h
//  PicFriendsApp
//
//  Created by Danny Witters on 26/01/2014.
//  Copyright (c) 2014 DWTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCell : UITableViewCell

@property(nonatomic,strong)UILabel *topText;
@property(nonatomic,strong)UILabel *bottomText;
@property(nonatomic,strong)UIImageView *profileImageView;
@property(nonatomic,strong)UIView *actionView;

@end
