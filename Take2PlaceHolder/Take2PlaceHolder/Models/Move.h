//
//  PlayerMove.h
//  Take2PlaceHolder
//
//  Created by Eric Zhang on 2/19/13.
//
//

#import "MoveType.h"

@interface Move : NSObject

@property (copy) NSString* TargetId;
@property MoveType Type;

+(Move* ) GetDefaultMove;
-(id) initWithTarget:(NSString *) target withType:(MoveType) type;

-(NSDictionary*) GetMove;

@end


