//
//  LandmarkViewController.h
//  VV-Application
//
//  Created by Nicholas Gordon on 10/7/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NinevehGL/NinevehGL.h>
#import "HomescreenViewController.h"
#import "AppDelegate.h"


@interface LandmarkViewController : UIViewController <NGLViewDelegate> {
    NGLMesh *mesh;
    NGLCamera *camera;
}

@property float rotateX;
@property float rotateY;
@property float rotateZ;

@property(nonatomic, weak) AppDelegate *myApp;

/**
 * Additional set up of view. Specifically, initialize view, and NGL framework for displaying 3D object
 */
- (void) viewDidLoad;
/**
 * Retrieves the name of the 3D object file that will be displayed in the view
 * return: String representing the name of the 3D object file for the landmark being viewed.
 */
-(NSString *) retrieveFileName;

/**
 * Initializes the NGL framework with a 3D object file
 * param: 3D object file to be loaded into NGL framework and displayed in the view.
 */
-(void) initNGL: (NSString *) fileName;

/**
 * Function to implement actions to be taken if application memory limit is reached.
 */
- (void)didReceiveMemoryWarning;

/**
 * Add functionality to NGL framework. I.e. rotation of object. In this case, set up the NGL camera, and set
 * mesh rotation fields to local variables representing rotate speeds in XYZ dimensions.
 */
-(void) drawView;

/**
 * IBAction called when user does a two finger rotate gesture. This rotates the 3D NGL object in the Z dimension.
 * param: UIRotationGestureRecognizer for the view.
 */
-(IBAction) twoFingerRotate:(UIRotationGestureRecognizer *) sender;

/**
 * IBAction called when user does a pan gesture. This rotates the 3D object in the X or Y dimensions depending on the
 * direction of the pan gesture
 * param: UIPanGestureRecognizer for the view
 */
-(IBAction) panHorizontal:(UIPanGestureRecognizer *) sender;

@end

