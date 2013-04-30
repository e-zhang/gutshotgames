//
//  MoveMenu.m
//  sumosmash
//
//  Created by Eric Zhang on 4/15/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MoveMenu.h"


@implementation MoveMenu

- (id)initWithFrame:(CGRect)frame andDelegate:(id<MoveMenuDelegate>)delegate forPlayer:(NSString *)playerId isSelf:(BOOL)isSelf 
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        _target = playerId;
        _isSelf = isSelf;
        
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    _container = [[UIView alloc] initWithFrame:self.frame];
    // 2
    CGFloat angleSize = M_PI/MOVECOUNT;
    // 3
    for (int i = 0; i < MOVECOUNT; i++) {
        // 4
        if(_isSelf && (i == ATTACK || i == SUPERATTACK)) continue;
        if(!_isSelf && (i == GETPOINTS || i == DEFEND)) continue;
        UIButton *im = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 25)];
        im.backgroundColor = [UIColor lightGrayColor];
        [im setTitle:MoveStrings[i] forState:UIControlStateNormal];
        im.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [im.titleLabel adjustsFontSizeToFitWidth];
        im.titleLabel.numberOfLines = 2;
        im.layer.anchorPoint = CGPointMake(1.0f, 1.0f);
        // 5
        im.layer.position = CGPointMake(_container.bounds.size.width/2.0,
                                        _container.bounds.size.height/2.0 + (MOVECOUNT/2-i)*20);
        im.transform = CGAffineTransformMakeRotation(angleSize * i);
        im.tag = i;
        // 6
        [im addTarget:self action:@selector(moveSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_container addSubview:im];
    }
    // 7
    _container.userInteractionEnabled = YES;
    [self addSubview:_container];
}


- (void) moveSelected:(UIButton*) sender
{
    if(![sender isEqual:_selectedMove])
    {
        [_selectedMove setSelected:NO];
        _selectedMove = sender;
    }
   
    Move* move = [[Move alloc] initWithTarget:_target withType:(MoveType) _selectedMove.tag];

    [_selectedMove setSelected:YES];

    [_delegate selectedItemChanged:move];
}


@end
