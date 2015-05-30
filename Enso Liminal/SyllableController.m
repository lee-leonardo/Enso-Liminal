//
//  SyllableController.m
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/7/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import "SyllableController.h"

@interface SyllableController ()

@end

@implementation SyllableController

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupQueue];
    }
    return self;
}

+(id)sharedInstance {
    static SyllableController *syllableCounter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        syllableCounter = [[self alloc] init];
    });
    
    return syllableCounter;
}

#pragma mark - Setup
-(void)setupQueue {
    _syllableQueue = [[NSOperationQueue alloc] init];
    _syllableQueue.name = @"hyphenator";
    _syllableQueue.qualityOfService = NSQualityOfServiceUtility;
    _syllableQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
}

#pragma mark - Notification Center
-(void)startListeningForPosts {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserverForName:EL_Haiku_Post object:self queue:_syllableQueue usingBlock:^(NSNotification *note) {
        NSDictionary *latestPost = [note userInfo];
        NSString *haikuPosted = latestPost[@"haiku"];
        
        // TODO: C Library to hyphenate text.
    }];
    
}

-(void)stopListeningForPosts {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:EL_Haiku_Post object:nil];
}

#pragma mark - Hyphenation and Syllables
#pragma mark External Interface
-(void)receivedText:(NSString *)toHyphenate {
    [_syllableQueue cancelAllOperations];
    [_syllableQueue addOperationWithBlock:^{
        // TODO: C Library to hyphenate text
        
    }];
}


@end
