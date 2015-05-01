// Template created By Colas Bardavid
// Copyright (c) 2014 Colas. All rights reserved.
//
//  CBDSwipeToPopTransitionManager.m
//  CREATION_NAVIGATION_CONTROLLER
//
//  Created by Colas on 01/05/2015.
//  Copyright (c) 2015 cassiopeia. All rights reserved.
//


#import "CBDPanToPopTransitionManager.h"

#import "MyCBDNavigationController.h"
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
#pragma mark - Constants
/**************************************/

static CGFloat const kDefaultFirstLimitValueForCompleting = 0.3f ;
static CGFloat const kDefaultSecondLimitValueForCompleting = 0.5f ;


static CGFloat const kBigVelocity = 500.0f ;
static CGFloat const kSmallVelocity = 50.0f ;


/**************************************/
#pragma mark - Private interface
/**************************************/

@interface CBDPanToPopTransitionManager ()

/*
 Parameters
 */


/*
 Components
 */
@property (nonatomic, strong, readwrite) UIPanGestureRecognizer * mainPanGestureRecognizer ;


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













@implementation CBDPanToPopTransitionManager




/**************************************/
#pragma mark - Init 
/**************************************/



- (instancetype)initWitMainViewForPanning:(UIView *)mainViewForSwiping
{
    self = [super initWithAnimator:nil] ;
    
    if (self)
    {
        /*
         Init
         */
        _firstLimitValueForCompleting = kDefaultFirstLimitValueForCompleting ;
        _secondLimitValueForCompleting = kDefaultSecondLimitValueForCompleting ;
        
        
        /*
         Gesture recognizer
         */
        _mainPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(mainPan:)] ;
        
        [mainViewForSwiping addGestureRecognizer:_mainPanGestureRecognizer] ;
    }
    
    return self ;
}



-(void)dealloc
{
    [self.mainPanGestureRecognizer.view removeGestureRecognizer:self.mainPanGestureRecognizer] ;
}





- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [super startInteractiveTransition:transitionContext];
}



- (void)mainPan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {

        BOOL leftToRight = [recognizer velocityInView:recognizer.view].x > 0;
        
        if (leftToRight)
        {
            [self.navigationController popViewControllerAnimated:YES
                                                 withInteraction:YES] ;
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        CGFloat d = translation.x / CGRectGetWidth(recognizer.view.bounds);

        [self updateInteractiveTransition:d*2];
    }
    else if (recognizer.state >= UIGestureRecognizerStateEnded)
    {
        NSLog(@"velocity : %f", [recognizer velocityInView:recognizer.view].x) ;
        
        if (
            (self.percentComplete > self.firstLimitValueForCompleting
            &&
             [recognizer velocityInView:recognizer.view].x > kSmallVelocity)
            ||
            [recognizer velocityInView:recognizer.view].x > kBigVelocity
            ||
            self.percentComplete > self.secondLimitValueForCompleting
            )
        {
            [self finishInteractiveTransition];
        }
        else
        {
            [self cancelInteractiveTransition];
        }
    }
}




@end
