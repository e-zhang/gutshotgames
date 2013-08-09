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
#import "SavedGames.h"


@interface Server : NSObject
{
    // CouchDB global
    CouchDatabase* _serverProfiles;
    CouchDatabase* _gameInvites;
    CouchDatabase* _games;
    CouchDatabase* _chat;
    
    // TouchDB local
    CouchDatabase* _localInfo;
    CouchDatabase* _invites;
    CouchDatabase* _localGames;
    
    UserAccount* _user;
    GameInvitations* _userInvitations;
    SavedGames* _savedGames;
    
}

@property (nonatomic, readonly) UserAccount* user;
@property (nonatomic, readonly) GameInvitations* gameInvitations;
@property (nonatomic, readonly) SavedGames* savedGames;

-(id) init;

-(void) initUser;

-(UserAccount*) GetUser:(NSString*) uuid;
-(GameInfo*) getGameForRequest:(GameRequest*) request;

-(GameInfo*) createNewGame:(NSString*) gameName;
-(CouchDocument*) createNewGameRequest:(NSString*) gameId;
-(GameInvitations*) getUserUpdate:(NSString*)player;

-(void) saveCreatedGame:(GameInfo*)game;

@end
