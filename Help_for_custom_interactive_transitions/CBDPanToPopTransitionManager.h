// Template created By Colas Bardavid
// Copyright (c) 2014 Colas. All rights reserved.
//
//  CBDSwipeToPopTransitionManager.h
//  CREATION_NAVIGATION_CONTROLLER
//
//  Created by Colas on 01/05/2015.
//  Copyright (c) 2015 cassiopeia. All rights reserved.
//

#import "AWPercentDrivenInteractiveTransition.h"




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

@class MyCBDNavigationController ;



@interface CBDPanToPopTransitionManager : AWPercentDrivenInteractiveTransition


- (instancetype)initWithAnimator:(id<UIViewControllerAnimatedTransitioning>)animator
                  viewForPopping:(UIView *)viewForPopping
              mainViewForPanning:(UIView *)mainViewForSwiping
         rightSideViewForPanning:(UIView *)rightSideViewForSwiping
                             for:(MyCBDNavigationController *)nvc ;

@end
