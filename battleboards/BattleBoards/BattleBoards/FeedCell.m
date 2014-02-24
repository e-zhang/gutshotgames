//
//  FeedCell.m
//  PicFriendsApp
//
//  Created by Danny Witters on 26/01/2014.
//  Copyright (c) 2014 DWTech. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15.0f, 15.0f, 30.0f, 30.0f)];
        self.profileImageView.layer.cornerRadius = 15.0f;
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.backgroundColor = [UIColor clearColor];
        
        self.topText = [[UILabel alloc]initWithFrame:CGRectMake(60.0f, 15.0f, 200.0f, 15.0f)];
        self.topText.textAlignment = NSTextAlignmentLeft;
        self.topText.font = [UIFont fontWithName:@"GillSans" size:10.0f];
        self.topText.backgroundColor = [UIColor clearColor];

        self.bottomText = [[UILabel alloc]initWithFrame:CGRectMake(60.0f, 30.0f, 160.0f, 15.0f)];
        self.bottomText.textAlignment = NSTextAlignmentLeft;
        self.bottomText.font = [UIFont fontWithName:@"GillSans" size:10.0f];
        self.bottomText.textColor = [UIColor colorWithRed:130.0/255.0f green:130.0/255.0f blue:130.0/255.0f alpha:1.0];
        self.bottomText.backgroundColor = [UIColor clearColor];

        self.actionView = [[UIView alloc] init];
        self.actionView.frame = CGRectMake(self.contentView.frame.size.width - 60.0f, 15.0f, 30.0f, 30.0f);
        self.actionView.layer.cornerRadius = 15.0f;
        self.actionView.backgroundColor = [UIColor greenColor];

        [self.contentView addSubview:self.topText];
        [self.contentView addSubview:self.bottomText];
        [self.contentView addSubview:self.profileImageView];
        [self.contentView addSubview:self.actionView];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 59.0f, self.frame.size.width, 1.0f)];
        line.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0];

        [self.contentView addSubview:line];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
