//
//  SyllableController.m
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/7/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import "SyllableController.h"

@interface SyllableController ()

@property (nonatomic) HyphenDict dict;
@property (nonatomic) HyphenState state;
@property (nonatomic) HyphenTrans trans;

@end

@implementation SyllableController

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupQueue];
        
        [self learnHyphenC];
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

-(void)setupHyphen {
    //Setup Trans
    
    //Setup State
    _state.trans = &_trans;
    
    //Setup Dictionary
    _dict.states = &_state;
    
}

-(void)learnHyphenC {
    char ** rep = NULL;
    int * pos = NULL;
    int * cut = NULL;
    char hyphens[MAXCHARLEN];
    
    int product = hnj_hyphen_hyphenate2(&_dict, "example", 7, hyphens, NULL, &rep, &pos, &cut);
    NSLog(@"%i", product);

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
