//
//  UserAccount.h
//  sumosmash
//
//  Created by Eric Zhang on 3/25/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//


#import <CouchCocoa/CouchCocoa.h>

typedef enum {
     NONE = 0,
     FACEBOOK = 1,
     GSG = 2
} UserType;

@interface UserAccount : CouchModel

@property (nonatomic) NSString* fb_id;
@property (nonatomic) NSString* fb_name;

@property (nonatomic) NSString* userid;

@property (nonatomic) NSString* username;
@property (nonatomic) NSString* password;
@property (nonatomic) NSString* email;

@property (nonatomic) NSDictionary* default_move;

//- (UserType) GetUserName:(NSString**) username Pic:(NSData**)userPic Id:(NSString**) userId;

//- (NSDictionary*) getUserPlayer;

@end
