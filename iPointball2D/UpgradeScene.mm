//
//  SceneName.m  <-- RENAME THIS
//  

#import "UpgradeScene.h"

@implementation UpgradeScene {
    NSUserDefaults* defaults;
    CCLabelTTF *dollarsLabel;
}
@synthesize iPad;

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
    //[SceneManager goMainMenu];
    [SceneManager goMainMenu];
}

- (void)addBackButton {

    if (self.iPad) {
        // Create a menu image button for iPad
        CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:@"Arrow-Normal-iPad.png" 
                                                         selectedImage:@"Arrow-Selected-iPad.png"
                                                                target:self 
                                                              selector:@selector(onBack:)];
        // Add menu image to menu
        CCMenu *back = [CCMenu menuWithItems: goBack, nil];

        // position menu in the bottom left of the screen (0,0 starts bottom left)
        back.position = ccp(64, 64);
        
        // Add menu to this scene
        [self addChild: back];
    }
    else {
        // Create a menu image button for iPhone / iPod Touch
        CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:@"Arrow-Normal-iPhone.png" 
                                                         selectedImage:@"Arrow-Selected-iPhone.png"
                                                                target:self 
                                                              selector:@selector(onBack:)];
        // Add menu image to menu
        CCMenu *back = [CCMenu menuWithItems: goBack, nil];

        // position menu in the bottom left of the screen (0,0 starts bottom left)
        back.position = ccp(32, 32);

        // Add menu to this scene
        [self addChild: back];        
    }
}

-(void)onMarker {
    [SceneManager goMarkerMenu];
}

-(void)onSkills {
    [SceneManager goSkillsMenu];
}

-(void)onPlayer {
    
}

- (void)buildUpgradeMenu {
    [CCMenuItemFont setFontSize:22];
    
    CCMenuItemFont* item1 = [CCMenuItemFont itemWithString:@"Player" target:self selector:@selector(onPlayer)];
    CCMenuItemFont* item2 = [CCMenuItemFont itemWithString:@"Marker" target:self selector:@selector(onMarker)];
    CCMenuItemFont* item3 = [CCMenuItemFont itemWithString:@"Skills" target:self selector:@selector(onSkills)];
    
    CCMenu* menu = [CCMenu menuWithItems:item1,item2,item3, nil];
    [menu alignItemsInRows:[NSNumber numberWithInt:3], nil];
    [menu setPosition:ccp(40, [CCDirector sharedDirector].winSize.height - 100)];
    [self addChild:menu];
}

- (id)init {
    
    if( (self=[super initWithColor:ccc4(97, 180, 207, 255)])) {
        
        // Determine Screen Size
        CGSize screenSize = [CCDirector sharedDirector].winSize;  
        
        // Calculate Large Font Size
        int largeFont = screenSize.height / kFontScaleTiny;
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        // Create a label
        dollarsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"$%i",[defaults integerForKey:@"player_dollars"]] fontName:@"Marker Felt" fontSize:largeFont];
        
		// Center label
		dollarsLabel.position = ccp( screenSize.width - 100, screenSize.height - 15);
        // Add label to this scene
		[self addChild:dollarsLabel z:0];

        //  Put a 'back' button in the scene
        [self addBackButton];
        
        [self buildUpgradeMenu];
    }
    return self;
}

@end
