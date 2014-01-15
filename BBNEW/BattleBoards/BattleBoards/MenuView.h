//
//  MenuView.h
//  sumosmash
//
//  Created by Danny Witters on 10/03/2013.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
#import "createaccount.h"
#import "GameViewController.h"
#import <FacebookSDK/FacebookSDK.h>


@interface MenuView : UIViewController<datadelegate,
                                       FBFriendPickerDelegate,
                                       UINavigationControllerDelegate,
                                       UICollectionViewDataSource,
                                       UISearchBarDelegate,
                                       UITextFieldDelegate>{
    UITextField *player1;
    Server* _gameServer;
}

@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (assign, nonatomic) BOOL showingFriendPicker;

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSString *searchText;
//@property (strong, nonatomic) IBOutlet UIView *selectedMenu;

@property (strong, nonatomic) NSArray *players;

@property (strong, nonatomic) IBOutlet UILabel *gridVal;
@property (strong, nonatomic) IBOutlet UISlider *gridSlider;
- (IBAction)sliderAction:(id)sender;

//createaccountbuttons
- (IBAction)createviafb:(id)sender;

- (IBAction)showCreateGame:(id)sender;

- (IBAction)onCreateNewGame:(id)sender;

- (IBAction)addplayer:(id)sender;

- (IBAction)submituser:(id) sender;

- (IBAction)gotodojo:(id)sender;

- (IBAction)resetMainMenu:(id) sender;

- (NSDictionary*) getPlayer:(NSString*) username;
- (NSDictionary*) getPlayerAccounts;
- (UIButton*) createGameButton:(NSDictionary*) invite atIndex:(int) idx;
- (void) SaveAccountInfo:(NSDictionary<FBGraphUser>*)fbUser;
- (void) sendRequests:(NSString*) gameId toPlayers:(NSDictionary*)players;

@end
