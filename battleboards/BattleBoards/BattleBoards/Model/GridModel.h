//
//  GridModel.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CouchCocoa/CouchCocoa.h>
#import "Player.h"

@interface GridModel : CouchModel<CouchDocumentModel>
{
    NSArray* _grid;
    NSMutableDictionary* _players;
}

-(id) initWithSize:(int) size;

-(id) getStateForRow:(int)row andCol:(int)col;
-(void) setState:(id)state forRow:(int)row andCol:(int)col;
-(void) addPlayer:(Player*)p;

-(void) couchDocumentChanged:(CouchDocument *)doc;

@property(readonly) NSDictionary* Players;

@end
