//
//  LandmarkViewController.m
//  VV-Application
//
//  Created by Nicholas Gordon on 10/7/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import "LandmarkViewController.h"

@interface LandmarkViewController ()

@end

@implementation LandmarkViewController
@synthesize rotateX, rotateY, rotateZ;
@synthesize myApp = _myApp;

/**
 * Retrieve the app delegate
 * return: App delegate instance
 */
- (AppDelegate *)myApp {
    if (_myApp == NULL) {
        _myApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return _myApp;
}


/**
 * Additional set up of view. Specifically, initialize view, and NGL framework for displaying 3D object
 */
- (void) viewDidLoad {
	[super viewDidLoad];
    [self initNGL: [self retrieveFileName]];
}
/**
 * Retrieves the name of the 3D object file that will be displayed in the view
 * return: String representing the name of the 3D object file for the landmark being viewed.
 */
-(NSString *) retrieveFileName {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *des = [NSEntityDescription entityForName:@"Landmark" inManagedObjectContext:self.myApp.coreData.managedObjectContext];
    [request setEntity:des];
    NSPredicate *query = [NSPredicate predicateWithFormat:@"landmark_name == %@", self.myApp.coreData.landmarkName];
    [request setPredicate:query];
    NSError *error = nil;
    NSArray *fetchResults = [self.myApp.coreData.managedObjectContext executeFetchRequest:request error:&error];
    NSString *description = ((Landmark *) [fetchResults objectAtIndex:0]).landmark_3d;
    return description;
}

/**
 * Initializes the NGL framework with a 3D object file
 * param: 3D object file to be loaded into NGL framework and displayed in the view.
 */
-(void) initNGL: (NSString *) fileName {
    NGLView *theView = [[NGLView alloc] initWithFrame:CGRectMake(185, 50, 650, 650)];
    theView.delegate = self;
    [self.view addSubview: theView];
    theView.contentScaleFactor = [[UIScreen mainScreen] scale];
	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys: kNGLMeshCentralizeYes, kNGLMeshKeyCentralize, @"0.3", kNGLMeshKeyNormalize, nil];
	mesh = [[NGLMesh alloc] initWithFile:[self.myApp.lib getResourceFilepath: fileName] settings:settings delegate:nil];
    camera = [[NGLCamera alloc] initWithMeshes:mesh, nil];
	[camera autoAdjustAspectRatio:YES animated:YES];
    [[NGLDebug debugMonitor] startWithView:theView];
}

/**
 * Function to implement actions to be taken if application memory limit is reached.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 * Add functionality to NGL framework. I.e. rotation of object. In this case, set up the NGL camera, and set
 * mesh rotation fields to local variables representing rotate speeds in XYZ dimensions.
 */
-(void) drawView {
    mesh.rotateY = rotateY;
    mesh.rotateX = rotateX;
    mesh.rotateZ = rotateZ;
    [camera drawCamera];
}

/**
 * IBAction called when user does a two finger rotate gesture. This rotates the 3D NGL object in the Z dimension.
 * param: UIRotationGestureRecognizer for the view.
 */
-(IBAction) twoFingerRotate:(UIRotationGestureRecognizer *) sender {
    rotateZ = [sender rotation] * 180/3.14;
}

/**
 * IBAction called when user does a pan gesture. This rotates the 3D object in the X or Y dimensions depending on the 
 * direction of the pan gesture
 * param: UIPanGestureRecognizer for the view
 */
-(IBAction) panHorizontal:(UIPanGestureRecognizer *) sender {
    rotateY += [sender velocityInView: self.view].x / 100.0;
    rotateX += [sender velocityInView: self.view].y / 100.0;
}

- (void) viewWillDisappear:(BOOL)animated {
    [EAGLContext setCurrentContext:nil];
}

 @end 
