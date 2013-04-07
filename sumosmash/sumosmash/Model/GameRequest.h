//
//  GameRequest.h
//  sumosmash
//
//  Created by Eric Zhang on 3/28/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//


@interface GameRequest : NSObject

@property (nonatomic) NSString* game_id;
@property (nonatomic) NSString* hostuserid;
@property (nonatomic) NSString* hostfbid;
@property (nonatomic) NSString* hostname;

-(NSDictionary*) getRequest;

@end
