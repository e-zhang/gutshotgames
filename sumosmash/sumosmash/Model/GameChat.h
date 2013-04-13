//
//  GameChat.h
//  sumosmash
//
//  Created by Eric Zhang on 4/13/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <CouchCocoa/CouchCocoa.h>

@protocol ChatUpdateDelegate <NSObject>

-(void) onChatUpdate:(int) count;

@end

@interface GameChat : CouchModel<CouchDocumentModel>
{
    id<ChatUpdateDelegate> _delegate;
}

@property (nonatomic) NSArray* chatHistory;

- (void) setDelegate:(id) delegate;

@end
