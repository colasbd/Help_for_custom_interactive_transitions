//
//  MyCBDNavigationController.h
//  CustompresentPop
//
//  Created by Colas on 02/04/2015.
//  Copyright (c) 2015 Robert Saunders. All rights reserved.
//

#import <UIKit/UIKit.h>





#pragma mark -
#pragma mark ________________________________________________________________
#pragma mark   ■■■■■■■■■■■■■■ ASSISTANT CLASSES ■■■■■■■■■■■■■■
#pragma mark ________________________________________________________________


@interface MyCBDTransitionForNavigationController : NSObject

@property (nonatomic, strong, readwrite) id <UIViewControllerAnimatedTransitioning> normalTransition ;
@property (nonatomic, strong, readwrite) id <UIViewControllerAnimatedTransitioning> reverseTransition ;

@end








#pragma mark -
#pragma mark ________________________________________________________________
#pragma mark   ■■■■■■■■■■■■■■ MAIN CLASS ■■■■■■■■■■■■■■
#pragma mark ________________________________________________________________





@interface MyCBDNavigationController : UIViewController



#pragma mark - Init

- (instancetype)initWithRootViewController:(UIViewController *)viewController
                                 withFrame:(CGRect)frame ;


#pragma mark - Object state
@property (nonatomic, weak, readonly) UIViewController * topViewController ;
@property (nonatomic, readonly) UIViewController * rootViewController ;


#pragma mark - Transition
@property (nonatomic, assign, readonly) MyCBDTransitionForNavigationController * nextPopTransition ;


#pragma mark - Core methods
- (void)pushViewController:(UIViewController *)viewController
            withTransition:(MyCBDTransitionForNavigationController *)transition ;


- (void)popViewControllerAnimated:(BOOL)animated ;
- (void)popViewControllerAnimated:(BOOL)animated
                  withInteraction:(BOOL)withInteraction ;

//– (void)popToRootViewControllerAnimated:(BOOL)animated ;
- (void)setViewControllers:(NSArray *)viewControllers
           withTransitions:(NSArray *)transitions
   withEffectiveTransition:(MyCBDTransitionForNavigationController *)transition ;


@property (nonatomic, strong, readonly) NSArray * viewControllers ;

@end




//@interface MyCBDNavigationController ()
//
//#pragma mark - Managing transitions
//@property (nonatomic, strong, readwrite) NSMutableArray * transitionTypes ; // to store the various transitions types
//- (MyCBDNavigationControllerTransition)inverseTransitionType:(MyCBDNavigationControllerTransition)transitionType ; // to "invert" a transition type
//@property (nonatomic, assign, readwrite) MyCustomTransitionManager * navigationManager ;
//
//@end
//
//
//
//
//@interface MyCustomTransitionManager : NSObject <UIViewControllerTransitioningDelegate>
//
//@property (nonatomic, assign, readwrite) MyCBDNavigationControllerTransition transitionType ;
//
///**
// Some parameters
// */
//@property (nonatomic, strong, readwrite) UIColor * backgroundColor ;
//@property (nonatomic, assign, readwrite) CGFloat opacity ;
//@property (assign, nonatomic, readwrite) NSTimeInterval durationTransition ;
//@property (assign, nonatomic, readwrite) CGFloat scale ;
//@property (assign, nonatomic, readwrite) CGFloat velocity ;
//
//@end
