//
//  ChapterSelect.m  <-- RENAME THIS
//  

#import "ChapterSelect.h"
#import "CCScrollLayer.h"
#import "Chapter.h"
#import "Chapters.h"
#import "ChapterParser.h"
#import "GameData.h"
#import "GameDataParser.h"

@implementation ChapterSelect
@synthesize iPad;

-(void)onSelectChapter:(CCMenuItemImage*)sender
{
    GameData *gameData = [GameDataParser loadData];
    [gameData setSelectedChapter:sender.tag];
    [GameDataParser saveData:gameData];
    [SceneManager goLevelSelect];
}

-(CCLayer*)layerWithChapterName:(NSString*)chapterName chapterNumber:(int)chapterNumber screenSize:(CGSize)screenSize
{
    CCLayer *layer = [[CCLayer alloc]init];
    
    if(self.iPad)
    {
        CCMenuItemImage *image = [CCMenuItemImage itemWithNormalImage:@"StickyNote-iPad.png" selectedImage:@"StickyNote-iPad.png" target:self selector:@selector(onSelectChapter:)];
        image.tag = chapterNumber;
        CCMenu* menu = [CCMenu menuWithItems:image, nil];
        [menu alignItemsVertically];
        [layer addChild:menu];
    }
    else{
        CCMenuItemImage *image = [CCMenuItemImage itemWithNormalImage:@"StickyNote-iPhone.png" selectedImage:@"StickyNote-iPhone.png" target:self selector:@selector(onSelectChapter:)];
        image.tag = chapterNumber;
        CCMenu* menu = [CCMenu menuWithItems:image, nil];
        [menu alignItemsVertically];
        [layer addChild:menu];
    }
    // Put a label in the new layer based on the passed chapterName
    int largeFont = [CCDirector sharedDirector].winSize.height / kFontScaleLarge;
    CCLabelTTF *layerLabel = [CCLabelTTF labelWithString:chapterName fontName:@"Marker Felt" fontSize:largeFont];
    layerLabel.position = ccp(screenSize.width/2,screenSize.height/2+10);
    layerLabel.rotation = -6.0f;
    layerLabel.color = ccc3(95, 58, 0);
    [layer addChild:layerLabel];
    
    return layer;
}

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
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

- (id)init {
    
    if( (self=[super init])) {
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        
        // Determine Screen Size
        CGSize screenSize = [CCDirector sharedDirector].winSize;  
        
        NSMutableArray* layers = [NSMutableArray new];
        
        Chapters* chapters = [ChapterParser loadData];
        GameData* gameData = [GameDataParser loadData];
        [LevelParser loadLevelsForChapter:gameData.selectedChapter];
        
        for(Chapter* chapter in chapters.chapters)
        {
            // Create a layer for each of the stages found in Chapters.xml
            CCLayer* layer = [self layerWithChapterName:chapter.name chapterNumber:chapter.number screenSize:screenSize];
            [layers addObject:layer];
        }
        
        CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:layers widthOffset:230];
        [scroller selectPage:(gameData.selectedChapter)-1];
        [self addChild:scroller];
        
        [scroller release];
        [layers release];

        //  Put a 'back' button in the scene
        [self addBackButton];   

    }
    return self;
}

@end
