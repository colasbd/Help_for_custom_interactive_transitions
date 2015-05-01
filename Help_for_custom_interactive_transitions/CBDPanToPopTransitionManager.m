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
@property (nonatomic, assign, readwrite) BOOL leftToRightTransition;
@property (nonatomic, assign, readwrite) BOOL interactionStarted ;

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

    self.interactionStarted = YES ;
    
    UIPanGestureRecognizer * recognizer = self.mainPanGestureRecognizer ;
    
    self.leftToRightTransition = [recognizer velocityInView:recognizer.view].x > 0;
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
        if (!self.leftToRightTransition) d *= -1;

        if (self.interactionStarted)
        {
            [self updateInteractiveTransition:d*0.5];
        }
    }
    else if (recognizer.state >= UIGestureRecognizerStateEnded)
    {
        if (self.percentComplete > 0.2)
        {
            self.interactionStarted = NO ;
            [self finishInteractiveTransition];
        }
        else
        {
            self.interactionStarted = NO ;
            [self cancelInteractiveTransition];
        }
    }
}




@end
