//
//  SceneName.m  <-- RENAME THIS
//  

#import "UpgradeScene.h"

@implementation UpgradeScene
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

-(void)changeSpeed {
    
}

-(void)changeAccuracy {
    
}

-(void)changeTriggerSpeed {
    
}

- (void)buildUpgradeMenu {
    CCMenuItemFont* item1 = [CCMenuItemFont itemWithString:@"Speed" target:self selector:@selector(changeSpeed)];
    CCMenuItemFont* item2 = [CCMenuItemFont itemWithString:@"Accuracy" target:self selector:@selector(changeAccuracy)];
    CCMenuItemFont* item3 = [CCMenuItemFont itemWithString:@"Trigger" target:self selector:@selector(changeTriggerSpeed)];
    
    CCMenu* menu = [CCMenu menuWithItems:item1,item2,item3, nil];
    [menu alignItemsInColumns:[NSNumber numberWithInt:3], nil];
    [self addChild:menu];
}

- (id)init {
    
    if( (self=[super initWithColor:ccc4(97, 180, 207, 255)])) {
        
        // Determine Screen Size
        CGSize screenSize = [CCDirector sharedDirector].winSize;  
        
        // Calculate Large Font Size
        int largeFont = screenSize.height / kFontScaleLarge; 
        
        // Create a label
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"New Scene"
                                               fontName:@"Marker Felt" 
                                               fontSize:largeFont];  
		// Center label
		label.position = ccp( screenSize.width/2, screenSize.height/2);  
        
        // Add label to this scene
		[self addChild:label z:0]; 

        //  Put a 'back' button in the scene
        [self addBackButton];
        
        [self buildUpgradeMenu];
    }
    return self;
}

@end
