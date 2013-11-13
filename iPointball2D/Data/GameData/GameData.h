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
    NSString* _player;
    NSString* _marker;
    int _fps;
    int _cash;
    int _paint;
}

// Declare your variable properties without an underscore, for example:
@property (nonatomic, assign) int selectedChapter;
@property (nonatomic, assign) int selectedLevel;
@property (nonatomic, assign) BOOL sound;
@property (nonatomic, assign) BOOL music;
@property (nonatomic, copy) NSString* player;
@property (nonatomic, copy) NSString* marker;
@property (nonatomic, assign) int fps;
@property (nonatomic, assign) int cash;
@property (nonatomic, assign) int paint;
   
// Put your custom init method interface here:
-(id)initWithSelectedChapter:(int)chapter selectedLevel:(int)level sound:(BOOL)sound music:(BOOL)music player:(NSString*)player marker:(NSString*)marker fps:(int)fps cash:(int)cash paint:(int)paint;

@end
