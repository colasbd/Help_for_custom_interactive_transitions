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



@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property MyCBDNavigationController * navigationController ;
@property (weak, nonatomic) IBOutlet UIView *viewForGestureRecognizer;

@property (nonatomic, strong, readwrite) CBDPanToPopTransitionManager * animationController ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ColorViewController * cvc = [ColorViewController new] ;
    
    CGRect frame = self.mainView.frame ;
    frame.origin = CGPointZero ;
    
    
    self.animationController = [[CBDPanToPopTransitionManager alloc] initWitMainViewForPanning:self.viewForGestureRecognizer] ;
    
    
    MyCBDNavigationController *nvc = [[MyCBDNavigationController alloc] initWithRootViewController:cvc
                                                                                         withFrame:frame withInteractionController:self.animationController] ;
    self.animationController.navigationController = nvc ; 
    
    nvc.view.backgroundColor = [UIColor blueColor] ;
    self.navigationController = nvc ;
    
    [self.mainView addSubview:nvc.view] ;
    
    
  
                                
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
    

        transition.normalTransition = [CBDPanAnimationController new] ;

    
    ColorViewController * cvc = [ColorViewController new] ;
    
    [self.navigationController pushViewController:cvc
                  withTransition:transition] ;
    
}

@end
