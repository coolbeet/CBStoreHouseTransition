CBStoreHouseTransition
========

What is it?
---

A custom transition inspired by [Storehouse](https://www.storehouse.co/) iOS app, also support pop gesture.

![screenshot] (https://s3.amazonaws.com/suyu.test/CBStoreHouseTransition.gif)

Video
---
[![CBStoreHouseTransition](http://img.youtube.com/vi/hSmsJNzopJ0/0.jpg)](http://www.youtube.com/watch?v=hSmsJNzopJ0)

Features
---

* One class file includes both pop and push transition and pop gesture.
* Fully customizable transition animation.
* Works for following iOS custom transition types:
  * `UINavigationController`push and pop
  * `UIViewController`presentations and dismissals

Which files are needed?
---
You only need to include `CBStoreHouseTransition (.h .m)` in your project, it contains both animator and interactive class.

CocoaPods support is coming very soon!

How to use it
---

For animator object you need to set proper `AnimationType` to match `UINavigationControllerOperation` object.

For interactive transition you need to attach current view controller using:
``` objective-c
- (void)attachToViewController:(UIViewController *)viewController;
```
A edge pan gesture will be added on the view controller's root view to handle the pop gesture and drive the interactive transition.

Then just return the proper animatior or interactive object in related delegate method, following is a  example using `CBStoreHouseTransition` for `UINavigationController`. 

For more information about iOS custom transition, please refer to [WWDC 2013](https://developer.apple.com/videos/wwdc/2013/) `Custom Transitions Using View Controllers` video.

``` objective-c
- (void)viewDidLoad
{
    ...
    self.animator = [[CBStoreHouseTransitionAnimator alloc] init];
    ...
}

- (void)viewDidAppear:(BOOL)animated
{
    ...
    self.navigationController.delegate = self;
    self.interactiveTransition = [[CBStoreHouseTransitionInteractiveTransition alloc] init];
    [self.interactiveTransition attachToViewController:self];
    ...
}

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

```

Since we don't need interactive for push transition or when user specificity taps back button, you need to set `self.interactive` to `nil`.

You can customize following properties to change the animation behavior:
``` objective-c
@property (nonatomic) CGFloat duration;
@property (nonatomic) CGFloat rotateAngle;
@property (nonatomic) CGFloat relativeDelayLeftView;
@property (nonatomic) CGFloat relativeDelayRightView;
@property (nonatomic) CGFloat percentageAdjustFactor;
```


