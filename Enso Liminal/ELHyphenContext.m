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
        self.uniqueIdentifier = [NSUUID UUID];
        self.syllableController = [SyllableController sharedInstance];
    }
    return self;
}

@end
