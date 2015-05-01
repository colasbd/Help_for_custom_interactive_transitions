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






@class MyCBDNavigationController ;



@interface CBDPanToPopTransitionManager : AWPercentDrivenInteractiveTransition


- (instancetype)initWitMainViewForPanning:(UIView *)mainViewForSwiping;

@property (nonatomic, weak, readwrite) MyCBDNavigationController * navigationController ;

@end
