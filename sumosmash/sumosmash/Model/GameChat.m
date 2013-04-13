//
//  GameChat.m
//  sumosmash
//
//  Created by Eric Zhang on 4/13/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import "GameChat.h"

@implementation GameChat

@dynamic chatHistory;

- (void) setDelegate:(id)delegate
{
    _delegate = delegate;
}

- (void) couchDocumentChanged:(CouchDocument *)doc
{
    [_delegate onChatUpdate:[self.chatHistory count]];
    
}

@end
