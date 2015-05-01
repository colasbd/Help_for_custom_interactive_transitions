# Help_for_custom_interactive_transitions


## what is my goal
My goal is to create a custom navigation container which is able to integrate in the iOS7 framework for custom and interactive transitions.
The big difference between `UINavigationController` and my custom navigation controller (named `MyCBDNavigationController`) is that it is not full screen. All happens in a frame that the user can specify at `init`. See the initializee of `MyCBDNavigationController`. 

## what is ok
As far as I don't use the interactive custom transitions, all is ok.

## what fails
When I want to implement an interactive transition, depending on a `UIPanGestureRecognizer`, I have a very strange behavior.
In the middle of the process (just after `updateInteractiveTransition:`), my context becomes `nil`. I don't understand how it is possible since I have a strong reference on it!!!

I don't use `UIPercentDrivenInteractiveTransition` but `AWPercentDrivenInteractiveTransition` (https://github.com/MrAlek/AWPercentDrivenInteractiveTransition) which has the same interface.
