//
//  SyllableController.m
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/7/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import "SyllableController.h"

@implementation SyllableController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _hyphenationEngine = [[JSContext alloc] init];
//        _hyphenationEngine[@"hyphenation"] = 
    }
    return self;
}

    //TODO: Need to work on porting over the Javascript library into the syllable counter.
-(void)hyphenateText:(NSString *)haiku {
    
    NSString *jsMethod = [NSString stringWithFormat:@"var hyphenated = hyphenation.hyphenateString(%@)", haiku];
    [_hyphenationEngine evaluateScript:jsMethod];
    
}

@end
