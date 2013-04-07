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

@synthesize user=_user;

NSString* const SERVER_HOST = @"sumowars.cloudant.com";
const int SERVER_PORT = 443;

-(id) init
{
    NSURLCredential* cred;
    cred = [NSURLCredential credentialWithUser: @"belfingsomplainkstralien"
                                      password: @"PgH7p07645rW7HALQaClDaNf"
                                   persistence: NSURLCredentialPersistencePermanent];
    NSURLProtectionSpace* space;
    space = [[NSURLProtectionSpace alloc] initWithHost: SERVER_HOST
                                                  port: SERVER_PORT
                                              protocol: @"https"
                                                 realm: @"SumoWars DB"
                                  authenticationMethod: NSURLAuthenticationMethodDefault];
    
    [[NSURLCredentialStorage sharedCredentialStorage] setDefaultCredential: cred
                                                        forProtectionSpace: space];
    
    NSURL* serverURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://%@", SERVER_HOST]];
    
    CouchServer* remoteServer = [[CouchServer alloc] initWithURL: serverURL];
    [remoteServer setCredential:cred];
    
    _serverProfiles = [remoteServer databaseNamed: DB_PROFILES];
    _docUpdate = [remoteServer databaseNamed: DB_UPDATES];
    _games = [remoteServer databaseNamed: DB_GAMES];
    
    CouchTouchDBServer* localServer = [CouchTouchDBServer sharedInstance];
    
    _localInfo = [localServer databaseNamed: @"my-database"];
    _invites = [localServer databaseNamed: @"invites"];
    _localGames = [localServer databaseNamed: @"localgames"];
    
    NSError* error;
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
 
}

-(UserAccount*) GetUser:(NSString *)uuid
{
    return [UserAccount modelForDocument:[_serverProfiles documentWithID:uuid]];
}

-(NSArray*) GetInvitationList
{
    NSMutableArray* gameinvitelist = [[NSMutableArray alloc] init];
    
    CouchQuery* query = [_invites getAllDocuments];
    for (CouchQueryRow* row in query.rows)
    {
        NSLog(@"row-%@",row.documentProperties);
        [gameinvitelist addObject:[GameInfo modelForDocument:row.document]];
    }
    
    return gameinvitelist;
}

-(GameInfo*) createNewGame:(NSString *)gameName
{
    CouchDocument* game = [_games documentWithID:gameName];
    return [GameInfo modelForDocument:game];
}

-(CouchDocument*) createNewGameRequest:(NSString*) gameId
{
    CouchDocument *request = [_invites documentWithID:gameId];
    return request;
}

-(CouchQuery*) getUserUpdates:(NSDictionary*)playerAccounts
{
    return [_docUpdate getDocumentsWithIDs:[playerAccounts allKeys]];
}

@end
