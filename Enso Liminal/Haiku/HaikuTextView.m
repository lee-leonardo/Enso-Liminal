//
//  HaikuTextView.m
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/25/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import "HaikuTextView.h"
#import "SyllableController.h"
#import "Enso_Liminal-Swift.h"

@interface HaikuTextView ()

@property (nonatomic, strong) SyllableController *syllableController;
@property (nonatomic, strong) NSRegularExpression *checkingExpression;
@property (nonatomic, copy) void (^stringCheckBlock)(NSTextCheckingResult *result,NSMatchingFlags flags, BOOL *stop);

@end

@implementation HaikuTextView

#pragma mark - Initialization
-(HaikuTextView *)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

+(HaikuTextView *)createViewWithFrame:(CGRect)frame {
    HaikuTextView *textView = [[self alloc] initWithFrame:frame];
    [textView maskingSetup];
    [textView checkingExpressionSetup];
    [textView reactiveCountSetup];
    textView.syllableController = [SyllableController sharedInstance];
    
    return textView;
}

#pragma mark - Setup
-(void)maskingSetup {
    CGFloat ratio = self.frame.size.width / 8;
    self.layer.cornerRadius = ratio;
    self.layer.masksToBounds = YES;
}

-(void)checkingExpressionSetup {
    NSString *disallowedCharacters = @"[~`@#$%^&*()-_=+{}\\;:\"<>]";
    NSError *error = NULL;
    NSRegularExpression *toCheckAgainst = [NSRegularExpression regularExpressionWithPattern:disallowedCharacters options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error != NULL) {
        NSLog(@"%@", error.localizedDescription);
        
    } else {
        self.checkingExpression = toCheckAgainst;
        
    }
    
    typedef void (^StringCheck)(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop);
    StringCheck checkString = ^void(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        //
    };
    self.stringCheckBlock = checkString;
}

-(void)reactiveCountSetup {
    //Not complete yet, need to test and see what I should do with it.
    [[self.rac_textSignal
      filter:^BOOL(NSString *givenString) {
        return [self checkString:givenString];
    }]
     subscribeNext:^(NSString *updatedString) {
        NSLog(@"String: %@", updatedString);
        NSLog(@"Length: %li", (long)updatedString.length);
        //self.syllableCount =
    }];
}

#pragma mark - Characters

//TODO: Break this into two functions.
-(BOOL)checkString:(NSString *)given {
    [self.checkingExpression enumerateMatchesInString:given
                                              options:0
                                                range:NSMakeRange(0, given.length)
                                           usingBlock:self.stringCheckBlock];
    
    return ([given rangeOfString:self.checkingExpression.pattern].location != NSNotFound) ? false : true;

}



@end
