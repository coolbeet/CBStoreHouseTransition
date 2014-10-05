//
//  ContentViewController.m
//  CBStoreHouseTransition
//
//  Created by coolbeet on 10/2/14.
//  Copyright (c) 2014 Suyu Zhang. All rights reserved.
//

#import "ContentViewController.h"
#import "CustomNavigationBar.h"
#import "CBStoreHouseTransition.h"

static CGFloat const navBarHeight = 64;

@interface ContentViewController () <UINavigationControllerDelegate>

@property (nonatomic) BOOL showBackButton;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, strong) CBStoreHouseTransitionAnimator *animator;
@property (nonatomic, strong) CBStoreHouseTransitionInteractiveTransition *interactiveTransition;

@end

@implementation ContentViewController

- (instancetype)initWithTitle:(NSString*)title contentImage:(UIImage*)image showBackButton:(BOOL)show
{
    self = [super init];
    if (self) {
        self.title = title;
        self.contentImage = image;
        self.showBackButton = show;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.animator = [[CBStoreHouseTransitionAnimator alloc] init];
    self.interactiveTransition = [[CBStoreHouseTransitionInteractiveTransition alloc] init];
    [self.interactiveTransition attachToViewController:self];
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] init];
    mainScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    mainScrollView.contentInset = UIEdgeInsetsMake(navBarHeight, 0, 0, 0);
    [self.view addSubview:mainScrollView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainScrollViewTapped)];
    [mainScrollView addGestureRecognizer:tapGesture];
    
    UIImageView *contentImageView = [[UIImageView alloc] init];
    contentImageView.translatesAutoresizingMaskIntoConstraints = NO;
    contentImageView.image = self.contentImage;
    [mainScrollView addSubview:contentImageView];
    
    CustomNavigationBar *navBar = [[CustomNavigationBar alloc] initWithTitle:self.title showBackButton:self.showBackButton];
    navBar.translatesAutoresizingMaskIntoConstraints = NO;
    [navBar.backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navBar];
    
    NSDictionary *viewsBindings = NSDictionaryOfVariableBindings(navBar, mainScrollView);
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSDictionary *metric = @{@"screenWidth":@(screenWidth), @"contentImageHeight":@(screenWidth/self.contentImage.size.width*self.contentImage.size.height)};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navBar]|" options:0 metrics:0 views:viewsBindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mainScrollView]|" options:0 metrics:0 views:viewsBindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navBar]" options:0 metrics:0 views:viewsBindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mainScrollView]|" options:0 metrics:0 views:viewsBindings]];
    [mainScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentImageView(screenWidth)]|" options:0 metrics:metric views:NSDictionaryOfVariableBindings(contentImageView)]];
    [mainScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentImageView(contentImageHeight)]|" options:0 metrics:metric views:NSDictionaryOfVariableBindings(contentImageView)]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self)
        self.navigationController.delegate = nil;
}

- (void)backButtonPressed:(id)sender
{
    //we don't need interactive transition for back button
    self.interactiveTransition = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mainScrollViewTapped
{
    NSString *title;
    UIImage *image;
    if ([self.title isEqualToString:@"Explore"]) {
        title = @"Storehouse";
        image = [UIImage imageNamed:@"home"];
    }
    else {
        title = @"Explore";
        image = [UIImage imageNamed:@"discover"];
    }
    
    ContentViewController *contentViewController = [[ContentViewController alloc] initWithTitle:title contentImage:image showBackButton:YES];
    [self.navigationController pushViewController:contentViewController animated:YES];
}

#pragma mark - Navigation Controller Delegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                 animationControllerForOperation:(UINavigationControllerOperation)operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *)toVC
{
    switch (operation) {
        case UINavigationControllerOperationPush:
            //we don't need interactive transition for push
            self.interactiveTransition = nil;
            self.animator.type = AnimationTypePush;
            return self.animator;
        case UINavigationControllerOperationPop:
            self.animator.type = AnimationTypePop;
            return self.animator;
        default:
            return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveTransition;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
