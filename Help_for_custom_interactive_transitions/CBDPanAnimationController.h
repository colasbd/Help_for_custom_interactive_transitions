// Template created By Colas Bardavid
// Copyright (c) 2014 Colas. All rights reserved.
//
//  CBDPanAnimationController.h
//  CREATION_NAVIGATION_CONTROLLER
//
//  Created by Colas on 30/04/2015.
//  Copyright (c) 2015 cassiopeia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBDReversibleAnimationController.h"





/**************************************/
#pragma mark - Enums
/**************************************/
/*
 The possible transitions
 */

typedef NS_ENUM(NSInteger, CBDPanTransitionType)
{
    CBDPanTransitionTypeTowardsLeft,
    CBDPanTransitionTypeTowardsRight,
    CBDPanTransitionTypeTowardsBottom,
    CBDPanTransitionTypeTowardsTop
};





@interface CBDPanAnimationController : CBDReversibleAnimationController


/*
 Parameters
 */
@property (assign, nonatomic, readwrite) CBDPanTransitionType transitionType ;

@property (assign, nonatomic, readwrite) CGFloat scale ;
@property (assign, nonatomic, readwrite) CGFloat velocity ;
@property (assign, nonatomic, readwrite) CGFloat initialOpacity ;

@property (nonatomic, copy, readwrite) UIColor * darkeningColor ;
@property (assign, nonatomic, readwrite) CGFloat finalDarkeningOpacity ;

@end
