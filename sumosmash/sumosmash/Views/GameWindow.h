//
//  GameWindow.h
//  sumosmash
//
//  Created by Danny Witters on 10/03/2013.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameInfo.h"

@interface GameWindow : UIViewController<GameUpdateDelegate,
                                         ChatUpdateDelegate,
                                         UITableViewDelegate,
                                         UITableViewDataSource,
                                         UITextViewDelegate>
{
    GameInfo* _game;
    NSString* _myPlayerId;
    NSString* _myPlayerName;
    int _gameStarted;
    UILabel *countdownLabel;
    NSMutableDictionary* _characters;
    NSMutableDictionary* _deadCharacters;
    
}

@property (strong, nonatomic) IBOutlet UILabel *status;
//@property (strong, nonatomic) IBOutlet UIView *movearea;
@property (strong, nonatomic) IBOutlet UIView *gamezone;
//@property (strong, nonatomic) IBOutlet UIButton *smbutton;
@property (strong, nonatomic) IBOutlet UITableView *chatTable;
@property (strong, nonatomic) IBOutlet UITextView *messageText;
@property (strong, nonatomic) IBOutlet UIButton *sendMessage;

- (IBAction)returntap:(id)sender;

- (IBAction)sendMessage:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil gameInfo:(GameInfo*)game myid:(NSString *) myid;
- (void) initPlayers;
- (BOOL) startGame;

- (void) submitMove:(Move*)move;

@end
