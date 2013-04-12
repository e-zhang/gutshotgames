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
#import "GameInvitations.h"


@interface Server : NSObject
{
    // CouchDB global
    CouchDatabase* _serverProfiles;
    CouchDatabase* _gameInvites;
    CouchDatabase* _games;
    
    // TouchDB local
    CouchDatabase* _localInfo;
    CouchDatabase* _invites;
    CouchDatabase* _localGames;
    
    UserAccount* _user;
    GameInvitations* _userInvitations;
    NSMutableArray* _gameInvitations;
    
    CouchReplication* _pull;
}

@property (nonatomic, readonly) UserAccount* user;
@property (nonatomic, readonly) NSArray* gameInvitations;

-(id) init;

-(void) initUser;

-(UserAccount*) GetUser:(NSString*) uuid;
-(void) getInvitations;

-(GameInfo*) createNewGame:(NSString*) gameName;
-(CouchDocument*) createNewGameRequest:(NSString*) gameId;
-(CouchQuery*) getUserUpdates:(NSDictionary*)playerAccounts;


@end
