//
//  GameData.m
//

#import "GameData.h"

@implementation GameData

// Synthesize your variables here, for example: 
@synthesize selectedChapter = _selectedChapter;
@synthesize selectedLevel = _selectedLevel;
@synthesize sound = _sound;
@synthesize music = _music;

// put your custom init method here which takes a variable 
// for each class instance variable
-(id)initWithSelectedChapter:(int)chapter selectedLevel:(int)level sound:(BOOL)sound music:(BOOL)music player:(NSString *)player marker:(NSString *)marker fps:(int)fps cash:(int)cash paint:(int)paint{

    if ((self = [super init])) {

        // Set class instance variables based on values 
        // given to this method
        self.selectedChapter = chapter;
        self.selectedLevel = level;
        self.sound = sound;
        self.music = music;
        self.player = player;
        self.marker = marker;
        self.fps = fps;
        self.cash = cash;
        self.paint = paint;
    }
    return self;
}



- (void) dealloc {
    [super dealloc];
}

@end