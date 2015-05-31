//
//  SyllableController.m
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/7/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import "SyllableController.h"

@interface SyllableController ()

@property (nonatomic, strong) NSCharacterSet *wordSeparators;

@end

@implementation SyllableController

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupQueue];
        [self setupWordSeparators];
        
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
-(void)setupWordSeparators {
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSMutableCharacterSet *punctuationAndWhitespace = [NSMutableCharacterSet punctuationCharacterSet];
    [punctuationAndWhitespace formUnionWithCharacterSet: whiteSpace];
    _wordSeparators = punctuationAndWhitespace;
}

#pragma mark LearningHyphenC
-(void)learnHyphenC {
    HyphenDict dict = [self createHyphenDictionary];
    char ** rep = NULL;
    int * pos = NULL;
    int * cut = NULL;
    char hyphens[MAXCHARLEN];
    
    int product = hnj_hyphen_hyphenate2(&dict, "example", 7, hyphens, NULL, &rep, &pos, &cut);
    NSLog(@"%i", product);

}


#pragma mark Hyphenation Library
-(HyphenDict)createHyphenDictionary {
    HyphenDict dict;
    HyphenState state;
    HyphenTrans trans;
    
    state.trans = &trans;
    dict.states = &state;
    
    return dict;
}

#pragma mark - Notification Center
-(void)startListeningForPosts {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserverForName:EL_Haiku_Post object:self queue:_syllableQueue usingBlock:^(NSNotification *note) {
        NSDictionary *latestPost = [note userInfo];
        NSString *haikuPosted = latestPost[@"haiku"];
        
        // TODO: C Library to hyphenate text.
//        [self handleHyphenation:haikuPosted];
        
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
#pragma mark Hyphenation
-(void)handleHyphenation:(NSString *)withString {
    int sum = 0;
    
    char **rep;
    int *pos = NULL;
    int *cut = NULL;
    char hyphens[MAXCHARLEN];
    
    NSArray *words = [withString componentsSeparatedByCharactersInSet:_wordSeparators];
    
    for (NSString *word in words) {
        NSLog(@"word: %@", word);
        int product = 0;
//        int product = hnj_hyphen_hyphenate2(&_dict, word, word.length, hyphens, <#char *hyphenated_word#>, <#char ***rep#>, <#int **pos#>, <#int **cut#>)
        sum += product;
    }
    
    free(rep);
    free(pos);
    free(cut);
    free(hyphens);
}


@end
