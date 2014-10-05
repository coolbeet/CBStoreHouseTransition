//
//  CBStoreHouseTransition.m
//  CBStoreHouseTransition
//
//  Created by coolbeet on 10/2/14.
//  Copyright (c) 2014 Suyu Zhang. All rights reserved.
//

#import "CBStoreHouseTransition.h"

#pragma mark - Animated Transitioning

@implementation CBStoreHouseTransitionAnimator

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.duration = 0.55;
        self.rotateAngle = M_PI_4;
        self.relativeDelayLeftView = 0.09;
        self.relativeDelayRightView = 0.12;
    }
    return self;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.layer.zPosition = fromViewController.view.layer.zPosition + 1;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CATransform3D leftViewTransfrom = CATransform3DIdentity;
    leftViewTransfrom.m34 = 1.0 / -500;
    leftViewTransfrom = CATransform3DRotate(leftViewTransfrom, self.rotateAngle, 0, 1, 0);
    leftViewTransfrom = CATransform3DTranslate(leftViewTransfrom, -screenWidth/2, 0, -screenWidth/2);
    
    CATransform3D rightViewTransfrom = CATransform3DIdentity;
    rightViewTransfrom.m34 = 1.0 / -500;
    rightViewTransfrom = CATransform3DTranslate(rightViewTransfrom, screenWidth, 0, 0);
    rightViewTransfrom = CATransform3DTranslate(rightViewTransfrom, -screenWidth/2, 0, 0);
    rightViewTransfrom = CATransform3DRotate(rightViewTransfrom, -self.rotateAngle, 0, 1, 0);
    rightViewTransfrom = CATransform3DTranslate(rightViewTransfrom, screenWidth/2, 0, 0);
    
    if (self.type == AnimationTypePush) {
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        toViewController.view.layer.transform = rightViewTransfrom;
        fromViewController.view.alpha = 1;

        [UIView animateKeyframesWithDuration:self.duration delay:0.0 options:0 animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
                fromViewController.view.layer.transform = leftViewTransfrom;
                fromViewController.view.alpha = 0;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:self.relativeDelayLeftView/self.duration relativeDuration:1 - self.relativeDelayLeftView/self.duration animations:^{
                toViewController.view.layer.transform = CATransform3DIdentity;
            }];

        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled])
                [transitionContext completeTransition:NO];
            else
                [transitionContext completeTransition:YES];
        }];
    }
    else {
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        toViewController.view.layer.transform = leftViewTransfrom;
        toViewController.view.alpha = 0;

        [UIView animateKeyframesWithDuration:self.duration delay:0.0 options:0 animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
                fromViewController.view.layer.transform = rightViewTransfrom;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:self.relativeDelayRightView/self.duration relativeDuration:1 - self.relativeDelayRightView/self.duration animations:^{
                toViewController.view.layer.transform = CATransform3DIdentity;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.85 animations:^{
                toViewController.view.alpha = 0.5;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.85 relativeDuration:0.15 animations:^{
                toViewController.view.alpha = 1;
            }];
            
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled])
                [transitionContext completeTransition:NO];
            else
                [transitionContext completeTransition:YES];
        }];
    }
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

@end

#pragma mark - Interactive Transitioning

@implementation CBStoreHouseTransitionInteractiveTransition

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.percentageAdjustFactor = 2.5;
    }
    return self;
}

- (void)attachToViewController:(UIViewController*)viewController
{
    self.parentViewController = viewController;
    UIScreenEdgePanGestureRecognizer *edgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePanRecognizer:)];
    edgePanRecognizer.edges = UIRectEdgeLeft;
    [self.parentViewController.view addGestureRecognizer:edgePanRecognizer];
}

- (void)handleEdgePanRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer
{
    NSAssert(self.parentViewController != nil, @"parent view controller was not set");
    CGFloat progress = [recognizer translationInView:self.parentViewController.view].x / self.parentViewController.view.bounds.size.width / self.percentageAdjustFactor;
    progress = MIN(1.0, MAX(0.0, progress));
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self.parentViewController.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged: {
            [self updateInteractiveTransition:progress];
            break;
        }
        default:
            if ([recognizer velocityInView:self.parentViewController.view].x >= 0) {
                [self finishInteractiveTransition];
                [self.parentViewController.view removeGestureRecognizer:recognizer];
            }
            else
                [self cancelInteractiveTransition];
            break;
    }
}

@end