//
//  MyCustomNavigationController.m
//  CustomPushPop
//
//  Created by Colas on 02/04/2015.
//  Copyright (c) 2015 Robert Saunders. All rights reserved.
//

#import "MyCBDNavigationController.h"


#import "AWPercentDrivenInteractiveTransition.h"
#import "CBDReversibleAnimationController.h"





#pragma mark -
#pragma mark ________________________________________________________________
#pragma mark   ■■■■■■■■■■■■■■ ASSISTANT CLASS 1 ■■■■■■■■■■■■■■
#pragma mark ________________________________________________________________



@implementation MyCBDTransitionForNavigationController : NSObject

@end





@implementation UIView (ASTEnhancements)

- (void)addAutoLayoutSubview:(UIView*)aSubView
{
    NSDictionary *views = NSDictionaryOfVariableBindings( aSubView );
    //[aSubView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview:aSubView];
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[aSubView]-0-|"
                                                                             options:0
                                                                             metrics:0
                                                                               views:views];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[aSubView]-0-|"
                                                                           options:0
                                                                           metrics:0
                                                                             views:views];
    
    [self addConstraints:horizontalConstraints];
    [self addConstraints:verticalConstraints];
}

@end









#pragma mark -
#pragma mark ________________________________________________________________
#pragma mark   ■■■■■■■■■■■■■■ ASSISTANT CLASS 2 ■■■■■■■■■■■■■■
#pragma mark ________________________________________________________________


/*
 https://github.com/objcio/issue-12-custom-container-transitions
 */


/** A private UIViewControllerContextTransitioning class to be provided transitioning delegates.
 @discussion Because we are a custom UIVievController class, with our own containment implementation, we have to provide an object conforming to the UIViewControllerContextTransitioning protocol. The system view controllers use one provided by the framework, which we cannot configure, let alone create. This class will be used even if the developer provides their own transitioning objects.
 @note The only methods that will be called on objects of this class are the ones defined in the UIViewControllerContextTransitioning protocol. The rest is our own private implementation.
 */
@interface MyCBDPrivateTransitionContext : NSObject <UIViewControllerContextTransitioning>

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController
                          toViewController:(UIViewController *)toViewController
                          inContainterView:(UIView *)containerView ; /// Designated initializer.


@property (nonatomic, copy) void (^completionBlock)(BOOL didComplete); /// A block of code we can set to execute after having received the completeTransition: message.
@property (nonatomic, assign, getter=isAnimated) BOOL animated; /// Private setter for the animated property.
@property (nonatomic, assign, getter=isInteractive) BOOL interactive; /// Private setter for the interactive property.
@end






@interface MyCBDPrivateTransitionContext ()
@property (nonatomic, strong) NSDictionary *privateViewControllers;
@property (nonatomic, assign) CGRect privateDisappearingFromRect;
@property (nonatomic, assign) CGRect privateAppearingFromRect;
@property (nonatomic, assign) CGRect privateDisappearingToRect;
@property (nonatomic, assign) CGRect privateAppearingToRect;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;
@property (nonatomic, assign) BOOL transitionWasCancelled;

@end




@implementation MyCBDPrivateTransitionContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController
                          toViewController:(UIViewController *)toViewController
                          inContainterView:(UIView *)containerView
{
    // NSAssert ([fromViewController isViewLoaded] && fromViewController.view.superview, @"The fromViewController view must reside in the container view upon initializing the transition context.");
    
    if ((self = [super init])) {
        self.presentationStyle = UIModalPresentationCustom;
        self.containerView = containerView;
        self.privateViewControllers = @{
                                        UITransitionContextFromViewControllerKey:fromViewController,
                                        UITransitionContextToViewControllerKey:toViewController,
                                        };
        
        // Set the view frame properties which make sense in our specialized ContainerViewController context. Views appear from and disappear to the sides, corresponding to where the icon buttons are positioned. So tapping a button to the right of the currently selected, makes the view disappear to the left and the new view appear from the right. The animator object can choose to use this to determine whether the transition should be going left to right, or right to left, for example.
        //CGFloat travelDistance = 500 ;
        self.privateDisappearingFromRect = self.privateAppearingToRect = self.containerView.bounds;
        self.privateDisappearingToRect = CGRectZero ;
        //CGRectOffset (self.containerView.bounds, travelDistance, 0);
        self.privateAppearingFromRect = CGRectZero ;
        //CGRectOffset (self.containerView.bounds, -travelDistance, 0);
    }
    
    return self;
}




- (CGRect)initialFrameForViewController:(UIViewController *)viewController {
    if (viewController == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.privateDisappearingFromRect;
    } else {
        return self.privateAppearingFromRect;
    }
}

- (CGRect)finalFrameForViewController:(UIViewController *)viewController {
    if (viewController == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.privateDisappearingToRect;
    } else {
        return self.privateAppearingToRect;
    }
}

- (UIViewController *)viewControllerForKey:(NSString *)key {
    return self.privateViewControllers[key];
}

- (UIView *)viewForKey:(NSString *)key
{
    return [self viewControllerForKey:key].view ;
}

- (void)completeTransition:(BOOL)didComplete {
    if (self.completionBlock) {
        self.completionBlock (didComplete);
    }
}

//- (BOOL)transitionWasCancelled { return NO; } // Our non-interactive transition can't be cancelled (it could be interrupted, though)

// Supress warnings by implementing empty interaction methods for the remainder of the protocol:

- (void)updateInteractiveTransition:(CGFloat)percentComplete {}
- (void)finishInteractiveTransition {
    self.transitionWasCancelled = NO;}
- (void)cancelInteractiveTransition {self.transitionWasCancelled = YES;}

@end

















#pragma mark -
#pragma mark ________________________________________________________________
#pragma mark   ■■■■■■■■■■■■■■ MAIN CLASS ■■■■■■■■■■■■■■
#pragma mark ________________________________________________________________



@interface MyCBDNavigationController ()

/*
 Components
 */
@property (nonatomic, strong, readwrite) NSMutableArray * mutableViewControllers ;
@property (nonatomic, strong, readwrite) NSMutableArray * mutableTransitions ;

@property (nonatomic, strong, readwrite) AWPercentDrivenInteractiveTransition * interactionController ;

/*
 Convenient properties
 */
@property (nonatomic, readonly) UIView * containerView ;

@property (nonatomic, weak, readwrite) UIViewController * selectedViewController ;


/*
 Object state
 */
@property (nonatomic, weak, readwrite) UIViewController * nextViewControllerToPop ;
@property (nonatomic, assign, readwrite) NSUInteger numberOfVCToBePushed ;
@property (nonatomic, assign, readwrite) NSUInteger numberOfVCToBePopped ;

@end




@implementation MyCBDNavigationController




/**************************************/
#pragma mark - Init
/**************************************/



- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
                                 withFrame:(CGRect)frame
                 withInteractionController:(id<UIViewControllerInteractiveTransitioning>)interactionController
{
    self = [super init] ;
    
    if (self)
    {
        /*
         Init
         */
        _numberOfVCToBePushed = 0 ;
        _numberOfVCToBePopped = 0 ;
        _mutableViewControllers = [NSMutableArray new] ;
        _mutableTransitions = [NSMutableArray new] ;
        
        /*
         Create the view
         */
        UIView * view ;
        view = [[UIView alloc] initWithFrame:frame] ;
        view.clipsToBounds = YES ;
        
        self.view = view ;
        
        
        /*
         Managing the root view controller
         */
        [_mutableViewControllers addObject:rootViewController] ;
        [self fillContainerViewWith:rootViewController.view] ;
        [self.mutableTransitions addObject:[NSNull null]] ;
        [rootViewController didMoveToParentViewController:self];
        
        
        
        
        /*
         Interaction Controller
         */
        _interactionController = interactionController ;
    }
    
    return self ;
}





/**************************************/
#pragma mark - Life cycle
/**************************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */






/**************************************/
#pragma mark - Convenient properties and assistant methods
/**************************************/


- (NSArray *)viewControllers
{
    return self.mutableViewControllers ;
}

- (UIViewController *)rootViewController
{
    return [self.mutableViewControllers firstObject] ;
}

- (UIView *)containerView
{
    return self.view ;
}


- (UIViewController *)topViewController
{
    return [self.mutableViewControllers lastObject] ;
}



- (UIViewController *)previousControllerThan:(UIViewController *)viewController
{
    if (viewController == self.rootViewController)
    {
        return nil ;
    }
    
    if (![self.viewControllers containsObject:viewController])
    {
        return nil ;
    }
    else
    {
        return [self.viewControllers objectAtIndex:[self.viewControllers indexOfObject:viewController] - 1] ;
    }
}

/**************************************/
#pragma mark - Managing the content view
/**************************************/


- (void)fillContainerViewWith:(UIView *)view
{
    view.translatesAutoresizingMaskIntoConstraints = YES ;
    //    [self.containerView addAutoLayoutSubview:view] ;
    
    
    //    CGRect frame = self.view.frame ;
    //    frame.origin = CGPointZero ;
    
    view.frame = self.containerView.bounds ;
    
    [self.view addSubview:view] ;
}




/**************************************/
#pragma mark - Core methods
/**************************************/


- (void)popViewControllerAnimated:(BOOL)animated
{
    [self popViewControllerAnimated:animated
                    withInteraction:NO] ;
}


- (void)popViewControllerAnimated:(BOOL)animated
                  withInteraction:(BOOL)withInteraction
{
    NSLog(@"to be popped: %ld", self.numberOfVCToBePopped) ;
    if (self.numberOfVCToBePushed > 0)
    {
        return ;
    }
    
    self.numberOfVCToBePopped++ ;
    
    
    UIViewController * poppedOutVC = self.nextViewControllerToPop ;
    
    /*
     Limit case
     */
    if (poppedOutVC == self.rootViewController
        ||
        !poppedOutVC)
    {
        self.numberOfVCToBePopped-- ;
        return ;
    }
    
    self.nextViewControllerToPop = [self previousControllerThan:poppedOutVC] ;
    
    
    /*
     Non-animated case
     */
    if (!animated)
    {
        [self.mutableViewControllers removeLastObject] ;
        [self.mutableTransitions removeLastObject] ;
        
        UIViewController * newTopVC = [self.mutableViewControllers lastObject] ;
        
        [self fillContainerViewWith:newTopVC.view] ;
        
        [poppedOutVC.view removeFromSuperview];
        [poppedOutVC removeFromParentViewController];
        self.numberOfVCToBePopped-- ;
    }
    
    
    /*
     Animated
     */
    else
    {
        /*
         Setting the animator
         */
        MyCBDTransitionForNavigationController * transition = [self.mutableTransitions lastObject] ;
        
        id<UIViewControllerAnimatedTransitioning>animator = transition.normalTransition ;
        
        if (transition.reverseTransition)
        {
            animator = transition.reverseTransition ;
        }
        else
        {
            CBDReversibleAnimationController * castedAnimator = transition.normalTransition ;
            
            castedAnimator.reverse = YES ;
            animator = castedAnimator ;
        }
        
        
        
        /*
         Setting the animator for the interactive manager
         */
        AWPercentDrivenInteractiveTransition * interactionController = nil ;
        if (withInteraction)
        {
            interactionController = self.interactionController ;
            interactionController.animator = animator ;
        }
        
        
        
        
        UIViewController * toViewController = [self previousControllerThan:poppedOutVC] ;
        
        MyCBDPrivateTransitionContext *transitionContext ;
        transitionContext = [[MyCBDPrivateTransitionContext alloc] initWithFromViewController:poppedOutVC
                                                                             toViewController:toViewController
                                                                             inContainterView:self.containerView];
        
        transitionContext.animated = YES;
        transitionContext.interactive = (interactionController != nil);
        transitionContext.completionBlock = ^(BOOL didComplete) {
            [poppedOutVC.view removeFromSuperview];
            [poppedOutVC removeFromParentViewController];
            
            [self.mutableViewControllers removeLastObject] ;
            [self.mutableTransitions removeLastObject] ;
            self.numberOfVCToBePopped-- ;
            
            
            if ([animator respondsToSelector:@selector (animationEnded:)]) {
                [animator animationEnded:didComplete];
            }
        };
        
        
        
        /*
         ****************
         CORE management of interaction !!
         ****************
         */
        if ([transitionContext isInteractive])
        {
            [interactionController startInteractiveTransition:transitionContext];
        }
        else
        {
            [animator animateTransition:transitionContext];
        }
    }
}







- (void)pushViewController:(UIViewController *)toViewController
            withTransition:(MyCBDTransitionForNavigationController *)transition
{
    if (self.numberOfVCToBePopped > 0)
    {
        return ;
    }
    
    
    self.numberOfVCToBePushed++ ;
    
    
    self.nextViewControllerToPop = toViewController ;
    
    
    /*
     From ViewController
     */
    UIViewController *fromViewController = ([self.mutableViewControllers count] > 0 ? [self.mutableViewControllers lastObject] : nil);
    if (toViewController == fromViewController || ![self isViewLoaded]) {
        self.numberOfVCToBePushed-- ;
        return;
    }
    
    
    [self addChildViewController:toViewController];
    [self.mutableViewControllers addObject:toViewController] ;
    [self.mutableTransitions addObject:transition] ;
    
    /*
     https://github.com/objcio/issue-12-custom-container-transitions
     */
    
    
    
    UIView *toView = toViewController.view;
    [toView setTranslatesAutoresizingMaskIntoConstraints:YES];
    toView.frame = self.view.bounds;
    
    [self addChildViewController:toViewController];
    
    
    
    
    id<UIViewControllerAnimatedTransitioning>animator = transition.normalTransition ;
    
    
    MyCBDPrivateTransitionContext *transitionContext ;
    transitionContext = [[MyCBDPrivateTransitionContext alloc] initWithFromViewController:fromViewController
                                                                         toViewController:toViewController
                                                                         inContainterView:self.containerView];
    
    transitionContext.animated = YES;
    transitionContext.interactive = NO;
    __weak typeof(self)weakSelf = self;
    transitionContext.completionBlock = ^(BOOL didComplete) {
        [fromViewController.view removeFromSuperview];
        [toViewController didMoveToParentViewController:self];
        weakSelf.numberOfVCToBePushed-- ;
        
        
        if ([animator respondsToSelector:@selector (animationEnded:)]) {
            
            [animator animationEnded:didComplete];
            
        }
    };
    
    [animator animateTransition:transitionContext];
    
    
    
    
}





@end
