// Template created By Colas Bardavid
// Copyright (c) 2014 Colas. All rights reserved.
//
//  CBDReversibleAnimationController.m
//  CREATION_NAVIGATION_CONTROLLER
//
//  Created by Colas on 30/04/2015.
//  Copyright (c) 2015 cassiopeia. All rights reserved.
//


#import "CBDReversibleAnimationController.h"


/*
 Model
 */


/*
 Components
 */


/*
 Services
 */


/*
 Categories
 */


/*
 Pods
 */













/**************************************/
#pragma mark - Private interface
/**************************************/

@interface CBDReversibleAnimationController ()

/*
 Parameters
 */


/*
 Components
 */


/*
 Object state
*/


/*
 Convenient properties
*/


/*
 References
 */





@end













@implementation CBDReversibleAnimationController




/**************************************/
#pragma mark - Init 
/**************************************/


- (id)init {
    if (self = [super init]) {
        self.duration = 2.0f;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    
    [self animateTransition:transitionContext
                     fromVC:fromVC
                       toVC:toVC
                   fromView:fromView
                     toView:toView];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView toView:(UIView *)toView
{
}





@end
