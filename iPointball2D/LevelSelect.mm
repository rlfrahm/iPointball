//
//  LevelSelect.mm
//  

#import "LevelSelect.h"
#import "Chapter.h"
#import "Chapters.h"
#import "ChapterParser.h"

@implementation LevelSelect
@synthesize iPad;

-(void)onPlay: (CCMenuItemImage*) sender
{
    // The selected level is determined by the tag in the menu item
    int selectedLevel = sender.tag;
    
    // Store the selected level in GameData
    GameData* gameData = [GameDataParser loadData];
    gameData.selectedLevel = selectedLevel;
    [GameDataParser saveData:gameData];
    
    // Load the game scene
    [SceneManager goGameScene];
}

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goChapterSelect];
}

- (void)addBackButton {

    if (self.iPad) {
        // Create a menu image button for iPad
        CCMenuItemImage *goBack = [CCMenuItemImage itemWithNormalImage:@"Arrow-Normal-iPad.png"
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
        CCMenuItemImage *goBack = [CCMenuItemImage itemWithNormalImage:@"Arrow-Normal-iPhone.png"
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

-(void)addLoadoutSelectButton {
    CCMenuItemFont* loadoutButton = [CCMenuItemFont itemWithString:@"Loadout" block:^(id sender){
        [SceneManager goLoadoutMenu];
    }];
    CCMenu* menu = [CCMenu menuWithItems:loadoutButton, nil];
    [menu setPosition:ccp(SCREEN.width - 80, 20)];
    [self addChild:menu];
}

- (id)init {
    
    if( (self=[super initWithColor:ccc4(97, 180, 207, 255)])) {
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        
        if(self.iPad)
        {
            self.device = @"iPad";
        }
        else
        {
            self.device = @"iPhone";
        }
        
        int smallFont = [CCDirector sharedDirector].winSize.height/kFontScaleSmall;
        
        // Read in selected chapter number
        GameData* gameData = [GameDataParser loadData];
        int selectedChapter = gameData.selectedChapter;
        
        // Read in selected chapter name (use load custom background later)
        NSString* selectedChapterName = nil;
        Chapters* selectedChapters = [ChapterParser loadData];
        for(Chapter* chapter in selectedChapters.chapters)
        {
            if([[NSNumber numberWithInt:chapter.number] intValue] == selectedChapter)
            {
                CCLOG(@"Selected Chapter is %@ (ie: number %i)", chapter.name, chapter.number);
                selectedChapterName = chapter.name;
            }
        }
        
        // Read in selected chapter levels
        CCMenu* levelMenu = [CCMenu menuWithItems: nil];
        NSMutableArray* overlay = [NSMutableArray new];
        
        Levels* selectedLevels = [LevelParser loadLevelsForChapter:gameData.selectedChapter];
        
        for(Level* level in selectedLevels.levels)
        {
            NSString* normal = [NSString stringWithFormat:@"%@-Normal-%@.png",selectedChapterName, self.device];
            NSString* selected = [NSString stringWithFormat:@"%@-Selected-%@.png",selectedChapterName, self.device];
            
            CCMenuItemImage* item = [CCMenuItemImage itemWithNormalImage:normal selectedImage:selected target:self selector:@selector(onPlay:)];
            [item setTag:level.number];
            [item setIsEnabled:level.unlocked];
            [levelMenu addChild:item];
            
            if(!level.unlocked)
            {
                NSString* overlayImage = [NSString stringWithFormat:@"Locked-%@.png", self.device];
                CCSprite* overlaySprite = [CCSprite spriteWithFile:overlayImage];
                [overlaySprite setTag:level.number];
                [overlay addObject:overlaySprite];
            }
            else{
                NSString* stars = [[NSNumber numberWithInt:level.stars] stringValue];
                NSString* overlayImage = [NSString stringWithFormat:@"%@Star-Normal-%@.png",stars,self.device];
                CCSprite* overlaySprite = [CCSprite spriteWithFile:overlayImage];
                [overlaySprite setTag:level.number];
                [overlay addObject:overlaySprite];
            }
        }
        
        [levelMenu alignItemsInColumns:
         [NSNumber numberWithInt:3],
         [NSNumber numberWithInt:0],
         [NSNumber numberWithInt:0], nil];
        
        // Move the whole menu up by a small percentage so it doesn't overlap the back button
        CGPoint newPosition = levelMenu.position;
        newPosition.y = newPosition.y + (newPosition.y/10);
        [levelMenu setPosition:newPosition];
        
        [self addChild:levelMenu z:-3];
        
        // Create layers for star/padlock overlays & level number labels
        CCLayer* overlays = [[CCLayer alloc]init];
        CCLayer* labels = [[CCLayer alloc]init];
        
        for(CCMenuItem* item in levelMenu.children)
        {
            // Create a label for every level
            CCLabelTTF* label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",item.tag] fontName:@"Marker Felt" fontSize:smallFont];
            [label setAnchorPoint:item.anchorPoint];
            [label setPosition:item.position];
            [labels addChild:label];
            
            // Set position of overlay sprites
            for(CCSprite* overlaySprite in overlay)
            {
                if(overlaySprite.tag == item.tag)
                {
                    [overlaySprite setAnchorPoint:item.anchorPoint];
                    [overlaySprite setPosition:item.position];
                    [overlays addChild:overlaySprite];
                }
            }
        }
        
        // Put the overlays and labels layers on the screen at the same position as the levelMenu
        [overlays setAnchorPoint:levelMenu.anchorPoint];
        [labels setAnchorPoint:levelMenu.anchorPoint];
        [overlays setPosition:levelMenu.position];
        [labels setPosition:levelMenu.position];
        [self addChild:overlays];
        [self addChild:labels];

        //  Put a 'back' button in the scene
        [self addBackButton];   
        [self addLoadoutSelectButton];
    }
    return self;
}

@end
