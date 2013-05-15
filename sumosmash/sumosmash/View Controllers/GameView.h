//
//  GameView.h
//  sumosmash
//
//  Created by Danny Witters on 10/03/2013.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameInfo.h"
#import "CharacterViewController.h"

@interface GameView : UIViewController<GameUpdateDelegate,
                                         ChatUpdateDelegate,
                                         CharacterDelegate,
                                         UITableViewDelegate,
                                         UITableViewDataSource,
                                         UITextFieldDelegate>
{
    GameInfo* _game;
    NSString* _myPlayerId;
    NSString* _myPlayerName;
    int _gameStarted;
    UILabel *countdownLabel;
    NSMutableDictionary* _characters;
    NSMutableDictionary* _deadCharacters;
    
    UILabel* _status;
    UITextView* _gameInfo;
    
    Move* _selectedMove;
    
}

@property (strong, nonatomic) IBOutlet UIImageView *gamezone;
//@property (strong, nonatomic) IBOutlet UIButton *smbutton;
@property (strong, nonatomic) IBOutlet UITableView *chatTable;
@property (strong, nonatomic) IBOutlet UITextField *messageText;

- (IBAction)returntap:(id)sender;

- (IBAction) textFieldDidBeginEditing:(UITextField *)textField;
- (IBAction) textFieldDidEndEditing:(UITextField *)textField;

- (void)sendMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil gameInfo:(GameInfo*)game myid:(NSString *) myid;
- (void) initPlayers;
- (BOOL) startGame;

@end