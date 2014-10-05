//
//  CustomNavigationBar.m
//  CBStoreHouseTransition
//
//  Created by coolbeet on 10/2/14.
//  Copyright (c) 2014 Suyu Zhang. All rights reserved.
//

#import "CustomNavigationBar.h"

@interface CustomNavigationBar ()

@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation CustomNavigationBar

- (id)initWithTitle:(NSString*)title showBackButton:(BOOL)show
{
    self = [super init];
    if (self) {
        self.showBackButton = show;
        
        self.toolbar = [[UIToolbar alloc] init];
        self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
        [self.toolbar setBarTintColor:[UIColor colorWithWhite:0.1 alpha:1]];//colorWithRed:0.13f green:0.14f blue:0.15f alpha:1.00f]];
        [self addSubview:self.toolbar];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
        self.backButton.hidden = !self.showBackButton;
        [self addSubview:self.backButton];
        
        NSDictionary *viewsBindings = NSDictionaryOfVariableBindings(_toolbar, _titleLabel, _backButton);
        NSDictionary *metric = @{@"width":@([UIScreen mainScreen].bounds.size.width), @"height": @(64), @"backButtonSize":@(44)};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar(width)]|" options:0 metrics:metric views:viewsBindings]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_toolbar(height)]|" options:0 metrics:metric views:viewsBindings]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|" options:0 metrics:metric views:viewsBindings]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_titleLabel(backButtonSize)]|" options:0 metrics:metric views:viewsBindings]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backButton(backButtonSize)]" options:0 metrics:metric views:viewsBindings]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_backButton(backButtonSize)]|" options:0 metrics:metric views:viewsBindings]];
    }
    return self;
}

- (void)setShowBackButton:(BOOL)showBackButton
{
    _showBackButton = showBackButton;
    self.backButton.hidden = !showBackButton;
}

@end
