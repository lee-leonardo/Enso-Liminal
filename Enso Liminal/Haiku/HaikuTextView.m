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

-(void)reactiveCountSetup {
    //Not complete yet, need to test and see what I should do with it.
    [self.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
        //self.syllableCount =
    }];
}

#pragma mark -


@end
