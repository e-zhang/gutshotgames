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
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

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
    UILabel* _countdownLabel;
    NSTimer* _countdownTimer;
    NSMutableDictionary* _characters;
    NSMutableDictionary* _deadCharacters;
    
    UILabel* _status;
    UITextView* _gameInfo;
    UITextView* _characterhistory;

    Move* _selectedMove;
    
    NSMutableDictionary *charidtonum;
    NSMutableDictionary *actions;
    
    //backgroundmusic
    //SystemSoundID backgroundbirds;
    AVAudioPlayer *player;
    
    UIButton* _submit;
}

//@property (strong, nonatomic) IBOutlet UIButton *smbutton;
@property (strong, nonatomic) IBOutlet UITableView *chatTable;
@property (strong, nonatomic) IBOutlet UITextField *messageText;
@property (strong, nonatomic) UIView *animationzone;
@property (strong, nonatomic) IBOutlet UIView *buttonslider;
@property (strong, nonatomic) IBOutlet UIView *slideoutleft;
@property (strong, nonatomic) IBOutlet UIView *righthandinfo;
@property (strong, nonatomic) IBOutlet UIButton *righthandbutton;

//buttons
@property (strong, nonatomic) IBOutlet UIButton *supera;
@property (strong, nonatomic) IBOutlet UIButton *a;
@property (strong, nonatomic) IBOutlet UIButton *defend;
@property (strong, nonatomic) IBOutlet UIButton *get5;

- (IBAction)returntap:(id)sender;

- (IBAction) textFieldDidBeginEditing:(UITextField *)textField;
- (IBAction) textFieldDidEndEditing:(UITextField *)textField;
- (IBAction)righthandexpand:(id)sender;
- (IBAction)submitmove:(id)sender;

- (IBAction)superaa:(id)sender;
- (IBAction)aa:(id)sender;
- (IBAction)defenda:(id)sender;
- (IBAction)get5a:(id)sender;

- (void)sendMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil gameInfo:(GameInfo*)game myid:(NSString *) myid;
- (void) initPlayers;
- (BOOL) startGame;


@end
