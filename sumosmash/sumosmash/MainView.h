//
//  MainView.h
//  sumosmash
//
//  Created by Danny Witters on 10/03/2013.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
#import "createaccount.h"
#import "GameWindow.h"
#import "Facebook.h"


@interface MainView : UIViewController<datadelegate, FBFriendPickerDelegate, UINavigationControllerDelegate, UISearchBarDelegate, UITextFieldDelegate>{
    UIView *user;
    UITextField *player1;
    Server* _gameServer;
}

@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (assign, nonatomic) BOOL showingFriendPicker;
@property (strong, nonatomic) Facebook *facebook;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) IBOutlet UIButton *cab;
@property (strong, nonatomic) IBOutlet UIView *centerviewarea;
@property (strong, nonatomic) IBOutlet UIView *createaccountcenter;
@property (strong, nonatomic) IBOutlet UIScrollView *gameinvitations;

@property (strong, nonatomic) NSMutableArray *players;

//createaccountbuttons
@property (strong, nonatomic) IBOutlet UITextField *accountusername;
@property (strong, nonatomic) IBOutlet UITextField *accountemail;
- (IBAction)createaccsubmit:(id)sender;
- (IBAction)createviafb:(id)sender;


- (IBAction)accessgi:(id)sender;

- (IBAction)creategame:(id)sender;

- (IBAction)addplayer:(id)sender;

- (IBAction)createaccount:(id)sender;

- (IBAction)startgame:(id)sender;

- (IBAction)gotodojo:(id)sender;

- (NSDictionary*) getPlayer:(NSString*) username;
- (NSDictionary*) getPlayerAccounts;
- (void) SaveAccountInfo:(NSDictionary<FBGraphUser>*)fbUser;
- (void) sendRequests:(NSString*) gameId toPlayers:(NSDictionary*)players;

@end
