//
//  ELHyphenContext.m
//  Enso Liminal
//
//  Created by Leonardo Lee on 5/16/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import "ELHyphenContext.h"
#import "SyllableController.h"

@interface ELHyphenContext ()

@property (nonatomic, strong) SyllableController *syllableController;

@end

@implementation ELHyphenContext

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.uniqueIdentifier = [self createUniqueHash];
        self.syllableController = [SyllableController sharedInstance];
        
        //Call methods that will setup the
    }
    return self;
}

-(NSString *)createUniqueHash {
    NSUUID *generatedId = [NSUUID UUID];
    
    NSArray *UUIDSegments = [generatedId.UUIDString componentsSeparatedByString:@"-"];
    NSString *withDashesRemoved = [NSString stringWithFormat:@"%@%@%@%@%@",
                                                           UUIDSegments[0],
                                                           UUIDSegments[1],
                                                           UUIDSegments[2],
                                                           UUIDSegments[3],
                                                           UUIDSegments[4]];
    
    return withDashesRemoved;
}

-(void)setupValueListener {
    
}

-(JSValue *)captureReference {
    
    
    return NULL;
}

-(NSUInteger)updateSyllableCount {
    
    
    return 0;
}

@end