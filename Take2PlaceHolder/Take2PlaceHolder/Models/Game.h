//
//  Game.h
//  Take2PlaceHolder
//
//  Created by Eric Zhang on 3/9/13.
//
//

#import <Foundation/Foundation.h>
#import <CouchCocoa/CouchCocoa.h>
#import "Move.h"

@protocol RoundCompleteEvent
@optional
-(void) OnRoundComplete;
-(void) UpdateMove:(Move*) move forPlayer:(NSString*) player;

@end

@interface Game : CouchModel <CouchDocumentModel>
{
    id<RoundCompleteEvent> _delegate;
}

@property (nonatomic, assign) id<RoundCompleteEvent> delegate;

@property (assign) NSArray* rounds;
@property (assign) NSString* host;
@property int num_players;
@property int current_round;



-(void) couchDocumentChanged:(CouchDocument *)doc;
-(void) RoundComplete;

@end
