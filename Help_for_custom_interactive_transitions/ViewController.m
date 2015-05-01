//
//  ViewController.m
//  Help_for_custom_interactive_transitions
//
//  Created by Colas on 01/05/2015.
//  Copyright (c) 2015 colas. All rights reserved.
//

#import "ViewController.h"

#import "ColorViewController.h"

#import "MyCBDNavigationController.h"
#import "CBDPanAnimationController.h"
#import "CBDPanToPopTransitionManager.h"
#import "CEPanAnimationController.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property MyCBDNavigationController * navigationController ;
@property (weak, nonatomic) IBOutlet UIView *viewForGestureRecognizer;

@property (nonatomic, strong, readwrite) CBDPanToPopTransitionManager * animationController ;




@property (weak, nonatomic) IBOutlet UIView *mainView2;
@property MyCBDNavigationController * navigationController2 ;
@property (weak, nonatomic) IBOutlet UIView *viewForGestureRecognizer2;

@property (nonatomic, strong, readwrite) CBDPanToPopTransitionManager * animationController2 ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ColorViewController * cvc = [ColorViewController new] ;
    cvc.label = @"INITIAL" ;
    CGRect frame = self.mainView.frame ;
    frame.origin = CGPointZero ;
    
    
    self.animationController = [[CBDPanToPopTransitionManager alloc] initWitMainViewForPanning:self.viewForGestureRecognizer] ;
    
    
    MyCBDNavigationController *nvc = [[MyCBDNavigationController alloc] initWithRootViewController:cvc
                                                                                         withFrame:frame withInteractionController:self.animationController] ;
    self.animationController.navigationController = nvc ; 
    
    nvc.view.backgroundColor = [UIColor blueColor] ;
    self.navigationController = nvc ;
    
    [self.mainView addSubview:nvc.view] ;
    
    
    
    
    
    
    
    
    ColorViewController * cvc2 = [ColorViewController new] ;
    cvc2.label = @"INITIAL" ;

    CGRect frame2 = self.mainView2.frame ;
    frame2.origin = CGPointZero ;
    
    
    self.animationController2 = [[CBDPanToPopTransitionManager alloc] initWitMainViewForPanning:self.viewForGestureRecognizer2] ;
    
    
    MyCBDNavigationController *nvc2 = [[MyCBDNavigationController alloc] initWithRootViewController:cvc2
                                                                                         withFrame:frame2 withInteractionController:self.animationController2] ;
    self.animationController2.navigationController = nvc2 ;
    
    nvc2.view.backgroundColor = [UIColor yellowColor] ;
    self.navigationController2 = nvc2 ;
    
    [self.mainView2 addSubview:nvc2.view] ;
  
                                
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/**************************************/
#pragma mark - Actions
/**************************************/

- (IBAction)remove:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES] ;
}



- (IBAction)add:(id)sender
{
    
    MyCBDTransitionForNavigationController * transition = [MyCBDTransitionForNavigationController new] ;
    

        transition.normalTransition = [CEPanAnimationController new] ;
    //transition.normalTransition = [CBDPanAnimationController new] ;

    
    ColorViewController * cvc = [ColorViewController new] ;
    
    [self.navigationController pushViewController:cvc
                  withTransition:transition] ;
    
}








- (IBAction)remove2:(id)sender
{
    [self.navigationController2 popViewControllerAnimated:YES] ;
}



- (IBAction)add2:(id)sender
{
    
    MyCBDTransitionForNavigationController * transition = [MyCBDTransitionForNavigationController new] ;
    
    
    // transition.normalTransition = [CEPanAnimationController new] ;
    transition.normalTransition = [CBDPanAnimationController new] ;
    
    
    ColorViewController * cvc = [ColorViewController new] ;
    
    [self.navigationController2 pushViewController:cvc
                                   withTransition:transition] ;
    
}

















@end
