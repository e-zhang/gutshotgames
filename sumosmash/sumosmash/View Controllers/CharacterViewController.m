//
//  CharacterViewController.m
//  sumosmash
//
//  Created by Eric Zhang on 4/17/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import "CharacterViewController.h"

@interface CharacterViewController ()
-(void) selectTarget:(UILongPressGestureRecognizer*) recognizer;

@end


@implementation CharacterViewController

@synthesize Display = _display, Char = _character;

- (id) initWithId:(NSString *)playerId name:(NSString*)name selfId:(NSString*)selfId delegate:(id<CharacterDelegate>)target
{
    if([super init])
    {
        _character = [[Character alloc] initWithId:playerId andName:name];
        
        _charDisplay = [[UILabel alloc] init];
        _charDisplay.textColor = [UIColor whiteColor];
        _charDisplay.backgroundColor = [UIColor clearColor];
        
        _charDisplay.font = [UIFont fontWithName:@"GillSans" size:10.0f];
        _charDisplay.textColor = [UIColor redColor];
        _charDisplay.numberOfLines = 2;
        
        _lifeDisplay = [[UILabel alloc] init];
        _lifeDisplay.textColor = [UIColor whiteColor];
        _lifeDisplay.backgroundColor = [UIColor clearColor];
        
        _lifeDisplay.font = [UIFont fontWithName:@"GillSans" size:10.0f];
        _lifeDisplay.textColor = [UIColor redColor];
        _lifeDisplay.numberOfLines = 1;
        
        _pointDisplay = [[UILabel alloc] init];
        _pointDisplay.textColor = [UIColor whiteColor];
        _pointDisplay.backgroundColor = [UIColor clearColor];
        
        _pointDisplay.font = [UIFont fontWithName:@"GillSans" size:10.0f];
        _pointDisplay.textColor = [UIColor redColor];
        _pointDisplay.numberOfLines = 1;
        
        _charDisplay.text = [NSString stringWithFormat:@"%@\nLast Move: %@",
                             _character.Name, MoveStrings[_character.NextMove.Type]];
        _lifeDisplay.text = [NSString stringWithFormat:@"Life: %d", _character.Life];
        _pointDisplay.text = [NSString stringWithFormat:@"Points: %d", _character.Points];
        _delegate = target;
        _isSelf= [playerId isEqual:selfId];
        
        self.view = [[UIView alloc] init];
        
        [_character addObserver:self forKeyPath:@"IsConnected" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [_character addObserver:self forKeyPath:@"IsTarget" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [_character addObserver:self forKeyPath:@"Life" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [_character addObserver:self forKeyPath:@"Points" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    
    return self;
}

- (void) setUserPic:(NSString*) path
{
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    _characterPic = [[UIImage alloc]initWithData:data];
    
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, 35, 35)];
    myImageView.userInteractionEnabled = YES;
    myImageView.image = _characterPic;
    
    [self.view addSubview: myImageView];
    [self.view addSubview:_lifeDisplay];
    [self.view addSubview:_pointDisplay];
    [self.view addSubview:_charDisplay];
    _lifeDisplay.frame = CGRectMake(0, 80,50,20);
    _pointDisplay.frame = CGRectMake(50, 80,50,20);
    _charDisplay.frame = CGRectMake(0, 60, 200, 25);
    
    _menuController = [[UIViewController alloc] init];
    _menuController.view = [[MoveMenu alloc] initWithFrame:CGRectMake(0,0,75,75) andDelegate:self forPlayer:_character.Id isSelf:_isSelf];
    
    [self addChildViewController:_menuController];
    
    UITapGestureRecognizer* longPress = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(selectTarget:)];
    [myImageView addGestureRecognizer:longPress];
}

- (void) setCharacterImage:(int) type path:(NSString*) path
{
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    _characterPic = [[UIImage alloc]initWithData:data];
    
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    myImageView.userInteractionEnabled = YES;
    myImageView.image = _characterPic;
    
    //golf swing
    
   /* UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    myImageView.userInteractionEnabled = YES;
    myImageView.tag = 100+type+1;
    NSLog(@"tag has been set. %d",myImageView.tag);
    if(type==0){
        myImageView.image = [UIImage imageNamed:@"golf wars normal 1.png"];
    }else{
        myImageView.image = [UIImage imageNamed:@"golf wars front swing.png"];
    }*/

    [self.view addSubview: myImageView];
    [self.view addSubview:_lifeDisplay];
    [self.view addSubview:_pointDisplay];
    [self.view addSubview:_charDisplay];
    _lifeDisplay.frame = CGRectMake(0, 80,50,20);
    _pointDisplay.frame = CGRectMake(50, 80,50,20);
    _charDisplay.frame = CGRectMake(0, 60, 200, 25);
    
    _menuController = [[UIViewController alloc] init];
    _menuController.view = [[MoveMenu alloc] initWithFrame:CGRectMake(0,0,200,60) andDelegate:self forPlayer:_character.Id isSelf:_isSelf];
    _menuController.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:_menuController];

    UITapGestureRecognizer* longPress = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(selectTarget:)];
    [myImageView addGestureRecognizer:longPress];
}

- (void) selectTarget:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"target-%ld",(long)recognizer.view.tag);
    for (UIImageView *a in [self.view subviews]) {
        NSLog(@"viewtags-%d",a.tag);
    }
    
    if(recognizer.state != UIGestureRecognizerStateEnded) return;
    
    if(![_menuController.view superview])
    {
        [self.view addSubview:_menuController.view];
        [self.view bringSubviewToFront:_menuController.view];
        self.view.userInteractionEnabled = YES;
        [_delegate onPressSelect:_character.Id];
        [_delegate showCharacterHistory:_character.Id];

    }
    else
    {
        [_menuController.view removeFromSuperview];
        [_delegate removeCharacterHistory:_character.Id];
    }
    
}

// MoveMenuDelegates
- (BOOL) selectedItemChanged:(Move *)move
{
    return [_delegate onMoveSelect:move];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if([keyPath isEqual:@"IsConnected"])
    {
        _lifeDisplay.textColor = [[change objectForKey:NSKeyValueChangeNewKey] boolValue] ?
                                      [UIColor blackColor] : [UIColor redColor];
        _pointDisplay.textColor = _lifeDisplay.textColor;
    }
    
    if([keyPath isEqual:@"IsTarget"])
    {
        BOOL value =[[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        if(!value && [_menuController.view superview])
        {
            [((MoveMenu*)_menuController.view) clearMove];
            [_menuController.view removeFromSuperview];
        }
    }
    
    
    if([keyPath isEqual:@"Life"])
    {
        _lifeDisplay.text = [NSString stringWithFormat:@"Life: %d", _character.Life];
        
        int oldValue = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
        if( oldValue > _character.Life )
        {
            _lifeDisplay.textColor = [UIColor redColor];
        }
        else
        {
            _lifeDisplay.textColor = [UIColor greenColor];
        }
        
        _charDisplay.text = [NSString stringWithFormat:@"%@\nLast Move: %@",
                             _character.Name, MoveStrings[_character.NextMove.Type]];
    }
    
    if([keyPath isEqual:@"Points"])
    {
        _pointDisplay.text = [NSString stringWithFormat:@"Points: %d", _character.Points];
        
        int oldValue = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
        if( oldValue > _character.Points)
        {
            _pointDisplay.textColor = [UIColor redColor];
        }
        else
        {
            _pointDisplay.textColor = [UIColor greenColor];
        }
        
        _charDisplay.text = [NSString stringWithFormat:@"%@     Last Move: %@",
                             _character.Name, MoveStrings[_character.NextMove.Type]];
    }
}

@end
