//
//  Server.m
//  sumosmash
//
//  Created by Eric Zhang on 3/24/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import "Server.h"

#include "DBDefs.h"

@implementation Server

@synthesize user=_user, gameInvitations=_userInvitations;

NSString* const SERVER_HOST = @"sumowars.cloudant.com";
const int SERVER_PORT = 443;

-(id) init
{
    NSURLCredential* cred;
    cred = [NSURLCredential credentialWithUser: @"sumowars"//@"belfingsomplainkstralien"
                                      password: @"sumowars123"//@"PgH7p07645rW7HALQaClDaNf"
                                   persistence: NSURLCredentialPersistencePermanent];
    NSURLProtectionSpace* space;
    space = [[NSURLProtectionSpace alloc] initWithHost: SERVER_HOST
                                                  port: SERVER_PORT
                                              protocol: @"https"
                                                 realm: @"SumoWars DB"
                                  authenticationMethod: NSURLAuthenticationMethodDefault];
    
    [[NSURLCredentialStorage sharedCredentialStorage] setDefaultCredential: cred
                                                        forProtectionSpace: space];
    
    NSURL* serverURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://%@:%@@%@",@"sumowars", @"sumowars123", SERVER_HOST]];
    
    NSError* error;
    CouchServer* remoteServer = [[CouchServer alloc] initWithURL: serverURL];
    [remoteServer setCredential:cred];
    
    _serverProfiles = [remoteServer databaseNamed: DB_PROFILES];
    _gameInvites = [remoteServer databaseNamed: DB_UPDATES];
    _games = [remoteServer databaseNamed: DB_GAMES];
    _chat = [remoteServer databaseNamed:DB_CHAT];
   
    _chat.tracksChanges = YES;
    _gameInvites.tracksChanges = YES;
    _games.tracksChanges = YES;
    
    
    CouchTouchDBServer* localServer = [CouchTouchDBServer sharedInstance];
    
    _localInfo = [localServer databaseNamed: @"my-database"];
    _invites = [localServer databaseNamed: @"invites"];
    _localGames = [localServer databaseNamed: @"localgames"];
    
    if (![_localInfo ensureCreated: &error] &&
        ![_invites ensureCreated: &error] &&
        ![_localGames ensureCreated: &error]) { NSLog(@"creation");}
    
    [self initUser];
    
    return self;
}

-(void) initUser
{
    CouchDocument *sup = [_localInfo documentWithID:@"maininfo"];
    
    NSLog(@"whereyouat-%@",sup.properties);
    _user = [UserAccount modelForDocument:sup];
    
    _userInvitations = [GameInvitations modelForDocument:
                        [_gameInvites documentWithID:self.user.userid]];
}

-(UserAccount*) GetUser:(NSString *)uuid
{
    return [UserAccount modelForDocument:[_serverProfiles documentWithID:uuid]];
}

-(GameInfo*) getGameFromRequest:(GameRequest*) request
{
    NSLog(@"request-%@",request);
    GameInfo* game = [GameInfo modelForDocument:
                      [_games documentWithID:request.game_id]];
    
    GameChat* chat = [GameChat modelForDocument:[_chat documentWithID:request.game_id]];
    
    [game setGameChat:chat];
    
    return game;
}

-(GameInfo*) createNewGame:(NSString *)gameName
{
    GameInfo* game = [GameInfo modelForDocument:[_games documentWithID:gameName]];
    GameChat* chat = [GameChat modelForDocument:[_chat documentWithID:gameName]];
    NSArray* welcome = [NSArray arrayWithObjects:@"sumosmash",
                                                [NSString stringWithFormat:@"Welcome to game: %@", gameName],
                                                nil];
    chat.chatHistory = [NSArray arrayWithObject:welcome];
    
    [[chat save] wait];
    
    [game setGameChat:chat];
    return game;
}

-(CouchDocument*) createNewGameRequest:(NSString*) gameId
{
    CouchDocument *request = [_invites documentWithID:gameId];
    return request;
}

-(GameInvitations*) getUserUpdate:(NSString*)player
{
    return [GameInvitations modelForDocument:[_gameInvites documentWithID:player]];
}

@end
