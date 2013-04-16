//
//  UserAccount.m
//  sumosmash
//
//  Created by Eric Zhang on 3/25/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import "UserAccount.h"
#include "DBDefs.h"

@implementation UserAccount

@dynamic fb_id, fb_name, userid, username, password, email;

-(UserType) GetUserName:(NSString *__autoreleasing *)username Pic:(NSData *__autoreleasing *) userPic Id:(NSString *__autoreleasing *) userId
{
    *userId = self.userid ? self.userid : @"";
    
    if(self.fb_id)
    {
        NSLog(@"heyllo-%@",self.fb_id);
        
        NSString *path = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", self.fb_id];
        
        NSURL *url = [NSURL URLWithString:path];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        *userPic = [NSData dataWithData:data];
        *username = [NSString stringWithString:self.fb_name];
        
        return FACEBOOK;
    }
    else if (self.username)
    {
        *username = [NSString stringWithString:self.username];
        
        return GSG;
    }
    
    return NONE;
}

- (NSDictionary*) getUserPlayer
{
    NSMutableDictionary* userAccount = [[NSMutableDictionary alloc] init];
    
    if(self.fb_name){
        [userAccount setObject:self.fb_name forKey:DB_USER_NAME];
        [userAccount setObject:self.fb_id forKey:DB_FB_ID];
        [userAccount setObject:self.userid forKey:DB_USER_ID];
    }
    else{
        [userAccount setObject:self.username forKey:DB_USER_NAME];
        [userAccount setObject:self.userid forKey:DB_USER_ID];
    }
    
    [userAccount setObject:[NSNumber numberWithBool:YES] forKey:@"connected"];
    return userAccount;
}


@end
