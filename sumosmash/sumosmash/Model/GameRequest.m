//
//  GameRequest.m
//  sumosmash
//
//  Created by Eric Zhang on 3/28/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import "GameRequest.h"

@implementation GameRequest

@synthesize game_id, hostuserid, hostfbid, hostname;


- (NSDictionary*) getRequest
{
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    [request setObject:self.game_id forKey:@"game_id"];
    [request setObject:self.hostuserid forKey:@"hostuserid"];
    
    // optional fields
    if( hostfbid ) [request setObject:self.hostfbid forKey:@"hostfbid"];
    if( hostname ) [request setObject:self.hostname forKey:@"hostname"];
    
    return request;
}

@end
