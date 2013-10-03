//
//  Levels.h  <-- RENAME TemplateData
//

@interface Levels : NSObject {  // <-- RENAME TemplateData

    // Declare variables with an underscore in front, for example:
    NSMutableArray* _levels;
}

// Declare your variable properties without an underscore, for example:
@property (nonatomic, retain) NSMutableArray* levels;

@end
