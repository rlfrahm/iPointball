//
//  GameData.h  <-- RENAME TemplateData
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject {  // <-- RENAME TemplateData

    // Declare variables with an underscore in front, for example:
    int _selectedChapter;
    int _selectedLevel;
    BOOL _sound;
    BOOL _music;
}

// Declare your variable properties without an underscore, for example:
@property (nonatomic, assign) int selectedChapter;
@property (nonatomic, assign) int selectedLevel;
@property (nonatomic, assign) BOOL sound;
@property (nonatomic, assign) BOOL music;
   
// Put your custom init method interface here:
-(id)initWithSelectedChapter:(int)chapter selectedLevel:(int)level sound:(BOOL)sound music:(BOOL)music;

@end
