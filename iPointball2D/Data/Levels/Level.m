//
//  Level.m  // <-- RENAME TemplateData
//

#import "Level.h"  // <-- RENAME TemplateData

@implementation Level  // <-- RENAME TemplateData

// Synthesize your variables here, for example: 
@synthesize name = _name;
@synthesize number = _number;
@synthesize unlocked = _unlocked;
@synthesize stars = _stars;
@synthesize data = _data;

// put your custom init method here which takes a variable 
// for each class instance variable
-(id)initWithName:(NSString *)name number:(int)number unlocked:(BOOL)unlocked stars:(int)stars data:(NSString *)data {

    if ((self = [super init])) {

        // Set class instance variables based on values 
        // given to this method
        self.name = name;
        self.number = number;
        self.unlocked = unlocked;
        self.stars = stars;
        self.data = data;
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}

@end