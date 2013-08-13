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

@synthesize user=_user, gameInvitations=_userInvitations, savedGames = _savedGames;

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
    
//    CouchDocument *sup = [_localInfo documentWithID:@"maininfo"];
//    NSMutableDictionary* add = [[NSMutableDictionary alloc] init];
//    [add setObject:@"AD4EDE5E-E9F0-4A78-AB6D-4D9F5AC821C8" forKey:@"userid"];
//    [add setObject:@"500386241" forKey:@"fb_id"];
//    [add setObject:@"Eric Zhang" forKey:@"fb_name"];
//    [add setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"AD4EDE5E-E9F0-4A78-AB6D-4D9F5AC821C8", @"target", [NSNumber numberWithInt:1], @"type", nil] forKey:@"default_move"];
//    
//    RESTOperation* operation = [sup putProperties:add];
//    if([operation wait:&error])
//    {
//        NSLog(@"%@", [error localizedDescription]);
//    }
//       
//    
//    NSLog(@"whereyouat-%@", sup.properties);
    
    [self initUser];
    [self initSavedGames];
    
    return self;
}


-(void) initSavedGames
{
    _savedGames = [SavedGames modelForDocument:[_localInfo documentWithID:@"savedgames"]];
    
    if(!_savedGames.savedGames)
    {
        _savedGames.savedGames = [[NSArray alloc] init];
    }
}

-(void) initUser
{
    CouchDocument *sup = [_localInfo documentWithID:@"maininfo"];
    _user = [UserAccount modelForDocument:sup];
    NSLog(@"whereyouat-%@",_user.document.properties);
    
    if(!self.user.userid) return;
    
    _userInvitations = [GameInvitations modelForDocument:
                        [_gameInvites documentWithID:self.user.userid]];
    
    if(_userInvitations && !_userInvitations.gameRequests)
    {
        _userInvitations.gameRequests = [[NSArray alloc] init];
        [[_userInvitations save] wait];
    }
}

-(UserAccount*) GetUser:(NSString *)uuid
{
    return [UserAccount modelForDocument:[_serverProfiles documentWithID:uuid]];
}

-(GameInfo*) getGameForRequest:(GameRequest*) request
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

-(void) saveCreatedGame:(GameInfo *)game
{
    NSMutableArray* gameList = [_savedGames.savedGames mutableCopy];
    NSDictionary* saveG = [NSDictionary dictionaryWithObjectsAndKeys:game.gameName, @"name", [game.players allKeys], @"players", nil];
    [gameList insertObject:saveG atIndex:0];
    if([gameList count] > 5)
    {
        [gameList removeLastObject];
    }
    
    _savedGames.savedGames = gameList;
    [[_savedGames save] wait];
}

@end
