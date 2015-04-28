//
//  HaikuTextView.m
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/25/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import "HaikuTextView.h"
#import "SyllableController.h"

@interface HaikuTextView ()

@property (nonatomic, strong) SyllableController *sharedSyllableController;

@end

@implementation HaikuTextView

-(HaikuTextView *)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

+(HaikuTextView *)createViewWithFrame:(CGRect)frame {
    HaikuTextView *textView = [[self alloc] initWithFrame:frame];
    [textView maskingSetup];
    [textView reactiveCountSetup];
    
    return textView;
}

+(HaikuTextView *)createViewWithFrame:(CGRect)frame
               withSyllableController:(SyllableController *)controller {
    
    HaikuTextView *textView = [self createViewWithFrame:frame];
    textView.sharedSyllableController = controller;
    
    return textView;
}

-(void)maskingSetup {
    CGFloat ratio = self.frame.size.width / 8;
    self.layer.cornerRadius = ratio;
    self.layer.masksToBounds = YES;
}

-(void)reactiveCountSetup {
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {}];

}

#pragma mark -


@end
