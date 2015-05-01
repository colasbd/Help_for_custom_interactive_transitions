# Please help me with custom interactive transitions


## My goal
My goal is to create a custom "navigation container" which integrates in the iOS7 framework for custom and interactive transitions (so, I make use of `UIViewControllerInteractiveTransitioning`, `UIViewControllerAnimatedTransitioning` and I also have my own implementation of `UIViewControllerContextTransitioning`, called `MyCBDPrivateTransitionContext`).

The big difference between `UINavigationController` and my custom navigation controller (named `MyCBDNavigationController`) is that it is not full screen. All happens in a frame that the user can specify at `init`. (see the initializer of `MyCBDNavigationController`)

## What is ok
As far as I don't use the interactive custom transitions, all is ok.

## What fails
When I want to implement an interactive transition, depending on a `UIPanGestureRecognizer`, I have a very strange behavior.
In the middle of the process (just after `updateInteractiveTransition:`), my transition context becomes `nil`. I don't understand how it is possible since I have a strong reference on it!!!

I don't use `UIPercentDrivenInteractiveTransition` but `AWPercentDrivenInteractiveTransition` ([code on github](https://github.com/MrAlek/AWPercentDrivenInteractiveTransition)) which has the same interface.


## Steps to Reproduce Issue
1. Download the project
- Launch it
- clik "add VC" several times (like 20 times)
- click one or two time on "pop last VC": you will see what the pop looks like
- now, pan from left to right on the red view. The last VC should pop, but it fails. Furthermore, afterwards, points 3. and 4. don' work anymore

As far as I debugged, the problem happens between line 
`[self updateInteractiveTransition:d*0.5];` of CBDPanToPopTransitionManager.m and `- (void)updateInteractiveTransition:(CGFloat)percentComplete` of AWPercentDrivenInteractiveTransition.m



## Help

 - my animator is called `CBDPanAnimationController`. It is a subclass of `CBDReversibleAnimationController`. It implements `UIViewControllerAnimatedTransitioning`.
 
 - the manager of interactive transitions is called `CBDPanToPopTransitionManager`. When I encounter the issue, I was writing it. It is a subclass of `AWPercentDrivenInteractiveTransition`. It implements `UIViewControllerInteractiveTransitioning`.
 
 - the implementation of `MyCBDPrivateTransitionContext` is the class `MyCBDPrivateTransitionContext` which is in the file `MyCBDNavigationController.m`
 
 - Finally, the custom navigation controller is `MyCBDNavigationController`.
 
 - This project is based upon the [github project](https://github.com/MrAlek/custom-container-transitions), which is commented by the author in [this blog](http://www.iosnomad.com/blog/2014/5/12/interactive-custom-container-view-controller-transitions).
