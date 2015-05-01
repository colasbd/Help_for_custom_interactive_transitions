// Template created By Colas Bardavid
// Copyright (c) 2014 Colas. All rights reserved.
//
//  CBDReversibleAnimationController.h
//  CREATION_NAVIGATION_CONTROLLER
//
//  Created by Colas on 30/04/2015.
//  Copyright (c) 2015 cassiopeia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



/**************************************/
#pragma mark - Declaration of constants
/**************************************/
//
//extern NSString* const <#example of a constant#> ;





/**************************************/
#pragma mark - Enums
/**************************************/
//
//typedef NS_ENUM(NSInteger, <#example of ENUM#>)
//{
//    <#example of ENUM#>Item1,
//    <#example of ENUM#>Item2,
//    <#example of ENUM#>Item3,
//};





@interface CBDReversibleAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

/**
 The direction of the animation.
 */
@property (nonatomic, assign) BOOL reverse;

/**
 The animation duration.
 */
@property (nonatomic, assign) NSTimeInterval duration;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView;


@end
