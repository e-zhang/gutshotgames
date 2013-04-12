//
//  GameInvitations.h
//  sumosmash
//
//  Created by Eric Zhang on 4/9/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <CouchCocoa/CouchCocoa.h>

#import "GameRequest.h"

@interface GameInvitations : CouchModel<CouchDocumentModel>

@property (nonatomic) NSArray* gameRequests;

@end
