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










///**************************************/
//#pragma mark - Enums
///**************************************/
//
//typedef NS_ENUM(NSInteger, <#example of ENUM#>)
//{
//    <#example of ENUM#>Item1,
//    <#example of ENUM#>Item2,
//    <#example of ENUM#>Item3,
//};











/**************************************/
#pragma mark - Instanciation of constants
/**************************************/

//static NSString* const <#example of a constant#> = @"Example of a constant";








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
@property (nonatomic, strong, readwrite) UITapGestureRecognizer * tapGestureRecognizer ;
@property (nonatomic, strong, readwrite) UIPanGestureRecognizer * mainPanGestureRecognizer ;
@property (nonatomic, strong, readwrite) UIPanGestureRecognizer * rightSideSwipeGestureRecognizer ;


/*
 Object state
*/
@property (nonatomic, assign, readwrite) BOOL leftToRightTransition;


/*
 Convenient properties
*/


/*
 References
 */
@property (nonatomic, weak, readwrite) MyCBDNavigationController * navigationController ;




@end













@implementation CBDPanToPopTransitionManager




/**************************************/
#pragma mark - Init 
/**************************************/



- (instancetype)initWithAnimator:(id<UIViewControllerAnimatedTransitioning>)animator
                  viewForPopping:(UIView *)viewForPopping
              mainViewForPanning:(UIView *)mainViewForSwiping
         rightSideViewForPanning:(UIView *)rightSideViewForSwiping
                             for:(MyCBDNavigationController *)nvc
{
    self = [super initWithAnimator:animator] ;
    
    if (self)
    {
        _navigationController = nvc ;
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(tap:)] ;
        
        _mainPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(mainPan:)] ;
        
        _rightSideSwipeGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(rightSidePan:)] ;
        
        [viewForPopping addGestureRecognizer:_tapGestureRecognizer] ;
        [mainViewForSwiping addGestureRecognizer:_mainPanGestureRecognizer] ;
        [rightSideViewForSwiping addGestureRecognizer:_rightSideSwipeGestureRecognizer] ;
    }
    
    return self ;
}



-(void)dealloc
{
    for (UIGestureRecognizer * reco in @[self.tapGestureRecognizer,
                                         self.mainPanGestureRecognizer,
                                         self.rightSideSwipeGestureRecognizer])
    {
        [reco.view removeGestureRecognizer:reco] ;
    }
}



- (void)tap:(UITapGestureRecognizer *)tapReco
{
    
}



- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [super startInteractiveTransition:transitionContext];

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

        [self updateInteractiveTransition:d*0.5];
    }
    else if (recognizer.state >= UIGestureRecognizerStateEnded)
    {
        if (self.percentComplete > 0.2)
        {
            [self finishInteractiveTransition];
        }
        else
        {
            [self cancelInteractiveTransition];
        }
    }
}



- (void)rightSidePan:(UITapGestureRecognizer *)tapReco
{
    
}



@end
