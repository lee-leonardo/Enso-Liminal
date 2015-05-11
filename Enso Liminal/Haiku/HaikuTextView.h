//
//  HaikuTextView.h
//  Enso Liminal
//
//  Created by Leonardo Lee on 4/25/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//
@class SyllableController;

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol HaikuViewDelegate <NSObject>

@end

@interface HaikuTextView : UITextView

@property (nonatomic) NSUInteger syllableCount;
@property (nonatomic, strong) RACSignal *syllableCounter;

+(HaikuTextView *)createViewWithFrame:(CGRect)frame;

@end
