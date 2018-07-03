//
//  PALoadFooterView.m
//  haofang
//
//  Created by leo on 14-9-9.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import "PALoadFooterView.h"

@interface PALoadFooterView ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation PALoadFooterView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}
         
- (void)_init {
    [self setBackgroundColor:[UIColor whiteColor]];

    // initialize
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
    self.indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [self addSubview:self.indicatorView];
}

- (void)startAnimation {
    [self.indicatorView startAnimating];
}

- (void)stopAnimation {
    [self.indicatorView stopAnimating];
}

@end
