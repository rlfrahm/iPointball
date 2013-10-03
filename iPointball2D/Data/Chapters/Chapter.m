//
//  Chapter.m
//

#import "Chapter.h"

@implementation Chapter

// Synthesize your variables here, for example: 
@synthesize name = _name;
@synthesize number = _number;

// put your custom init method here which takes a variable 
// for each class instance variable
-(id)initWithName:(NSString *)name number:(int)number {

    if ((self = [super init])) {

        // Set class instance variables based on values 
        // given to this method
        self.name = name;
        self.number = number;
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}

@end