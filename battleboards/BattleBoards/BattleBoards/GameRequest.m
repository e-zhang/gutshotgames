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

-(id) initWithProperties:(NSDictionary *)properties
{
    if([super init])
    {
        self.game_id = [properties objectForKey:GAME_ID];
        self.hostuserid = [properties objectForKey:@"hostuserid"];
        
        // optional fields
        self.hostfbid = [properties objectForKey:@"hostfbid"];
        self.hostname = [properties objectForKey:@"hostname"];
    }
    
    return self;
}

- (NSDictionary*) getRequest
{
    NSMutableDictionary* request = [[NSMutableDictionary alloc] init];
    [request setObject:self.game_id forKey:GAME_ID];
    [request setObject:self.hostuserid forKey:@"hostuserid"];
    
    // optional fields
    if( hostfbid ) [request setObject:self.hostfbid forKey:@"hostfbid"];
    if( hostname ) [request setObject:self.hostname forKey:@"hostname"];
    
    return request;
}

@end
