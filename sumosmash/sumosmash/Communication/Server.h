//
//  Server.h
//  sumosmash
//
//  Created by Eric Zhang on 3/24/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchCocoa/CouchCocoa.h>
#import "UserAccount.h"
#import "GameInfo.h"


@interface Server : NSObject
{
    // CouchDB global
    CouchDatabase* _serverProfiles;
    CouchDatabase* _docUpdate;
    CouchDatabase* _games;
    
    // TouchDB local
    CouchDatabase* _localInfo;
    CouchDatabase* _invites;
    CouchDatabase* _localGames;
    
    UserAccount* _user;
}

@property (nonatomic, readonly) UserAccount* user;

-(id) init;

-(void) initUser;

-(UserAccount*) GetUser:(NSString*) uuid;
-(NSArray*) GetInvitationList;

-(GameInfo*) createNewGame:(NSString*) gameName;
-(CouchDocument*) createNewGameRequest:(NSString*) gameId;
-(CouchQuery*) getUserUpdates:(NSDictionary*)playerAccounts;


@end
