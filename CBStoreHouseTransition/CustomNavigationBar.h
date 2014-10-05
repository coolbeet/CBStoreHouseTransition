//
//  CustomNavigationBar.h
//  CBStoreHouseTransition
//
//  Created by coolbeet on 10/2/14.
//  Copyright (c) 2014 Suyu Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationBar : UIView

- (id)initWithTitle:(NSString*)title showBackButton:(BOOL)show;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic) BOOL showBackButton;

@end
