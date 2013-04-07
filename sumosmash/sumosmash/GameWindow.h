//
//  GameWindow.h
//  sumosmash
//
//  Created by Danny Witters on 10/03/2013.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameInfo.h"

@interface GameWindow : UIViewController<GameUpdateDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    GameInfo* _game;
    NSString* _myPlayerId;
    int _gameStarted;
    UILabel *countdownLabel;
    NSMutableDictionary* _characters;
    NSMutableDictionary* _deadCharacters;
}

@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UIView *movearea;
@property (strong, nonatomic) IBOutlet UIPickerView *targetPicker;
@property (strong, nonatomic) IBOutlet UITextField *playerattack;
@property (strong, nonatomic) IBOutlet UIScrollView *scrolldata;
@property (strong, nonatomic) IBOutlet UIButton *smbutton;

- (IBAction)moveselected:(id)sender;

- (IBAction)returntap:(id)sender;

- (IBAction)submitmove:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil gameInfo:(GameInfo*)game myid:(NSString *) myid;
- (void) initPlayers;
- (BOOL) startGame;

@end
