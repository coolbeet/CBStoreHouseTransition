//
//  CBStoreHouseTransition.h
//  CBStoreHouseTransition
//
//  Created by coolbeet on 10/2/14.
//  Copyright (c) 2014 Suyu Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    AnimationTypePush = 0,
    AnimationTypePop
} AnimationType;

@interface CBStoreHouseTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/**
 *  AnimationType includes AnimationTypePush and AnimationTypePop. 
 *  Default is AnimationTypePush.
 */
@property (nonatomic, assign) AnimationType type;

/**
 * The total duration time of entire transition.
 * Default value is 0.55.
 */
@property (nonatomic) CGFloat duration;

/**
 * The angle of both view controller'view rotates.
 * Default value is M_PI_4.
 */
@property (nonatomic) CGFloat rotateAngle;

/**
 * The relative delay duration for the view on the left.
 * This value must be in the range 0 to 1.
 * Default value is 0.09.
 */
@property (nonatomic) CGFloat relativeDelayLeftView;

/**
 * The relative delay duration for the view on the right.
 * This value must be in the range 0 to 1.
 * Default value is 0.12.
 */
@property (nonatomic) CGFloat relativeDelayRightView;

@end

@interface CBStoreHouseTransitionInteractiveTransition : UIPercentDrivenInteractiveTransition

/**
 * The view controller will be driven.
 * Must use attachToViewController: to setup before transition begins.
 * Default value is 2.5.
 */
@property (nonatomic, weak) UIViewController *parentViewController;

/**
 * The purpose of this factor is make sure views movement follows user's finger when transition is happenning.
 * May need to adjust the animation timing curve also if need.
 */
@property (nonatomic) CGFloat percentageAdjustFactor;

/**
 *  Use this method to attach the view controller to be popped. A edge pan gesture will be added
 *  on the view controller's root view to handle the pop gesture and drive the interactive transition.
 */
- (void)attachToViewController:(UIViewController *)viewController;

@end
