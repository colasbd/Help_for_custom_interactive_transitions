// Template created By Colas Bardavid
// Copyright (c) 2014 Colas. All rights reserved.
//
//  CBDPanAnimationController.m
//  CREATION_NAVIGATION_CONTROLLER
//
//  Created by Colas on 30/04/2015.
//  Copyright (c) 2015 cassiopeia. All rights reserved.
//


#import "CBDPanAnimationController.h"


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
#pragma mark - Instanciation of constants
/**************************************/

static NSTimeInterval const kDefaultDurationTransition = 1.0 ;
static NSTimeInterval const kDefaultScale = 1 ;
static NSTimeInterval const kDefaultVelocity = 0.5 ;
static NSTimeInterval const kDefaultFinalDarkeningOpacity = 0 ;
static NSTimeInterval const kDefaultInitialOpacity = 1 ;







/**************************************/
#pragma mark - Private interface
/**************************************/

@interface CBDPanAnimationController ()

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













@implementation CBDPanAnimationController




/**************************************/
#pragma mark - Init
/**************************************/


- (instancetype)init
{
    self = [super init] ;
    
    if (self)
    {
        /*
         Parameters
         */
        //self.duration = kDefaultDurationTransition ;
        _scale = kDefaultScale ;
        _velocity = kDefaultVelocity ;
        _finalDarkeningOpacity = kDefaultFinalDarkeningOpacity ;
        _initialOpacity = kDefaultInitialOpacity ;
        _darkeningColor = [UIColor blackColor] ;
    }
    
    return self ;
}



- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)oldSubview
                   toView:(UIView *)newView
{
    if (!self.reverse)
    {
        [self _normal_animateTransition:transitionContext
                                 fromVC:fromVC
                                   toVC:toVC
                               fromView:oldSubview
                                 toView:newView] ;
    }
    else
    {
        [self _reverse_animateTransition:transitionContext
                                  fromVC:fromVC
                                    toVC:toVC
                                fromView:oldSubview
                                  toView:newView] ;
    }
}



- (void)_reverse_animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                            fromVC:(UIViewController *)fromVC
                              toVC:(UIViewController *)toVC
                          fromView:(UIView *)fromView
                            toView:(UIView *)toView
{
    /*
     **************************************
     **************************************
     Limit case: the view does not change
     **************************************
     **************************************
     */
    if (toView == fromView)
    {
        [transitionContext completeTransition:NO] ;
        return ;
    }
    
    
    /*
     Parameters
     */
    UIView* containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    
    
    /*
     Starting point for the old view
     */
    fromView.transform = CGAffineTransformIdentity;
    
    
    
    /*
     Darkening old view
     */
    UIView * darkeningView = [[UIView alloc] initWithFrame:fromView.bounds] ;
    darkeningView.backgroundColor = self.darkeningColor ;
    darkeningView.alpha = self.finalDarkeningOpacity ;
    
    [toView addSubview:darkeningView] ;
    
    
    
    
    /*
     Placing the new view
     */
    toView.translatesAutoresizingMaskIntoConstraints = YES ;
    toView.frame = containerView.bounds ;
    
    [containerView insertSubview:toView
                    belowSubview:fromView] ;
    [containerView layoutIfNeeded] ;
    
    
    CGAffineTransform referenceTransform = [self startingTransformForViewControllerTransition:self.transitionType
                                                                                   forContext:transitionContext] ;
    
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform,
                                       -referenceTransform.tx * self.velocity,
                                       -referenceTransform.ty * self.velocity,
                                       0) ;
    
    transform = CATransform3DScale(transform,
                                   self.scale,
                                   self.scale,
                                   1) ;
    
    
    toView.layer.transform = transform ;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:0
                     animations:^{
                         /*
                          Arrival point for the old view
                          */
                         fromView.transform = referenceTransform;
                         
                         fromView.alpha = kDefaultInitialOpacity ;
                         
                         
                         
                         
                         
                         /*
                          Arrival point for the new view
                          */
                         darkeningView.alpha = 0 ;
                         
                         toView.transform = CGAffineTransformIdentity;
                         
                         
                         
                         /*
                          Update the constraints
                          */
                         [containerView layoutIfNeeded] ;
                     }
                     completion:^(BOOL finished) {
                         
                         /*
                          Apple mechanism
                          */
                         if ([transitionContext transitionWasCancelled])
                         {
                             toView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
                             fromView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
                         }
                         else
                         {
                             // reset from- view to its original state
                             [fromView removeFromSuperview];
                             //fromView.frame = CGRectMake(!self.reverse ? -160 : 320, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
                             //oView.frame = CGRectMake(0, 0, toView.frame.size.width, toView.frame.size.height);
                         }
                         
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         
                         
                         /*
                          We remove the oldSubview
                          and reset the parameters
                          */
                         fromView.alpha = 1 ;
                         fromView.layer.transform = CATransform3DIdentity ;
                         [darkeningView removeFromSuperview] ;
                         
                         
                         
                         
                         
                         
//                         fromView.transform = CGAffineTransformIdentity;
//                         fromView.alpha = 1;
//                         [darkeningView removeFromSuperview] ;
//                         
//                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         

                         
                         
                     }];
    
    
}


- (void)_normal_animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                           fromVC:(UIViewController *)fromVC
                             toVC:(UIViewController *)toVC
                         fromView:(UIView *)fromView
                           toView:(UIView *)toView
{
    /*
     **************************************
     **************************************
     Limit case: the view does not change
     **************************************
     **************************************
     */
    if (toView == fromView)
    {
        [transitionContext completeTransition:NO] ;
        return ;
    }
    
    
    /*
     Parameters
     */
    UIView* containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    
    
    /*
     Starting point for the old view
     */
    fromView.transform = CGAffineTransformIdentity;
    
    
    
    /*
     Placing the new view
     */
    toView.translatesAutoresizingMaskIntoConstraints = YES ;
    toView.frame = containerView.bounds ;
    [containerView addSubview:toView] ;
    [containerView layoutIfNeeded] ;
    
    
    /*
     Starting point for the new view
     */
    toView.transform = [self startingTransformForViewControllerTransition:self.transitionType
                                                               forContext:transitionContext];
    toView.alpha = kDefaultInitialOpacity ;
    
    
    
    
    
    /*
     Darkening old view
     */
    UIView * darkeningView = [[UIView alloc] initWithFrame:fromView.bounds] ;
    darkeningView.backgroundColor = self.darkeningColor ;
    darkeningView.alpha = 0 ;
    [fromView addSubview:darkeningView] ;
    
    
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:0
                     animations:^{
                         /*
                          Arrival point for the old view
                          */
                         darkeningView.alpha = self.finalDarkeningOpacity ;
                         
                         CATransform3D transform = CATransform3DIdentity;
                         transform = CATransform3DTranslate(transform,
                                                            -toView.transform.tx * self.velocity,
                                                            -toView.transform.ty * self.velocity,
                                                            0) ;
                         
                         transform = CATransform3DScale(transform,
                                                        self.scale,
                                                        self.scale,
                                                        1) ;
                         
                         
                         fromView.layer.transform = transform ;
                         
                         
                         
                         /*
                          Arrival point for the new view
                          */
                         toView.transform = CGAffineTransformIdentity;
                         toView.alpha = 1 ;
                         
                         
                         
                         /*
                          Update the constraints
                          */
                         [containerView layoutIfNeeded] ;
                     }
                     completion:^(BOOL finished) {
                         
                         /*
                          Apple mechanism
                          */
                         //                         if ([transitionContext transitionWasCancelled])
                         //                         {
                         //                             toView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
                         //                             fromView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
                         //                             fromView.layer.transform = CATransform3DIdentity ;
                         //                         }
                         //                         else
                         //                         {
                         //                             // reset from- view to its original state
                         //                             [fromView removeFromSuperview];
                         //                             //fromView.frame = CGRectMake(!self.reverse ? -160 : 320, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
                         //                             toView.frame = CGRectMake(0, 0, toView.frame.size.width, toView.frame.size.height);
                         //                         }
                         //                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         //
                         //
                         //
                         //                         /*
                         //                          We remove the oldSubview
                         //                          and reset the parameters
                         //                          */
                         //                         fromView.alpha = 1 ;
                         //                         fromView.layer.transform = CATransform3DIdentity ;
                         //                         [darkeningView removeFromSuperview] ;
                         
                         
                         fromView.transform = CGAffineTransformIdentity;
                         fromView.alpha = 1;
                         [darkeningView removeFromSuperview] ;
                         
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         
                     }];
    
    
}
















- (CGAffineTransform)startingTransformForViewControllerTransition:(CBDPanTransitionType)transition
                                                       forContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView * containerView = [transitionContext containerView] ;
    
    CGFloat width = CGRectGetWidth(containerView.bounds);
    CGFloat height = CGRectGetHeight(containerView.bounds);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    
    
    switch (transition)
    {
        case CBDPanTransitionTypeTowardsBottom:
            transform = CGAffineTransformMakeTranslation(0, -height);
            break;
        case CBDPanTransitionTypeTowardsRight:
            transform = CGAffineTransformMakeTranslation(-width, 0);
            break;
        case CBDPanTransitionTypeTowardsLeft:
            transform = CGAffineTransformMakeTranslation(width, 0);
            break;
        case CBDPanTransitionTypeTowardsTop:
            transform = CGAffineTransformMakeTranslation(0, height);
            break;
        default:
            break;
    }
    
    return transform;
}




@end
