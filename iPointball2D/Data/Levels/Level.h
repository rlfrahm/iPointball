//
//  Level.h
//

#import <Foundation/Foundation.h>

@interface Level : NSObject {

    // Declare variables with an underscore in front, for example:
    NSString* _name;
    int _number;
    BOOL _unlocked;
    int _stars;
    NSString* _data;
}

// Declare your variable properties without an underscore, for example:
@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) BOOL unlocked;
@property (nonatomic, assign) int stars;
@property (nonatomic, copy) NSString* data;
   
// Put your custom init method interface here:
-(id)initWithName:(NSString*)name number:(int)number unlocked:(BOOL)unlocked stars:(int)stars data:(NSString*)data;

@end
