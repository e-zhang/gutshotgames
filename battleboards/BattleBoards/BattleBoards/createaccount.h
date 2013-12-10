//
//  createaccount.h
//  Wipe
//
//  Created by Danny Witters on 05/02/2013.
//  Copyright (c) 2013 Danny Witters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"
#import <AudioToolbox/AudioToolbox.h>

@protocol datadelegate <NSObject>
-(void) secondViewControllerDismissed:(NSDictionary *)data;
@end

@interface createaccount : UIViewController <FBUserSettingsDelegate, UITextFieldDelegate>{
    SystemSoundID click;
    SystemSoundID back;
}

@property (strong, nonatomic) IBOutlet UITextField *email;

@property (strong, nonatomic) IBOutlet UITextField *username;

@property (strong, nonatomic) id <datadelegate>delegate;

- (IBAction)returntap:(id)sender;

- (IBAction)loginfacebook:(id)sender;

@end
