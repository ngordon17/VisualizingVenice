//
//  IntermediateViewController.m
//  VV-Application
//
//  Created by Nicholas Gordon on 10/5/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import "IntermediateViewController.h"
#import "HomescreenViewController.h"
#import "MapAnnotation.h"


@implementation IButton
@synthesize text, title;
@end

@interface IntermediateViewController()
@end

@implementation IntermediateViewController
@synthesize myApp = _myApp;
@synthesize landmarkImage;
@synthesize rotation = _rotation;
@synthesize popover = _popover;

/**
 * Retrieve the app delegate
 * return: App delegate instance
 */
- (AppDelegate *)myApp {
    if (!_myApp) {
        _myApp = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _myApp;
}

/**
 * Additional set up of view. Specifically, loads an image of the landmark being viewed.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.rotation = @"N";
    [self rotateView:nil];
}

/**
 * Upon the click of the "rotate view" button in the view fetches a new perspective for the landmark being viewed and 
 * replaces the current perspective of the landmark image with the new one.
 * param: UIBarButtonItem i.e. "rotate view" button
 */
- (IBAction)rotateView:(UIBarButtonItem *)sender {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *des = [NSEntityDescription entityForName:@"Landmark" inManagedObjectContext:self.myApp.coreData.managedObjectContext];
    [request setEntity:des];
    NSPredicate *query = [NSPredicate predicateWithFormat:@"landmark_name == %@", self.myApp.coreData.landmarkName];
    [request setPredicate:query];
    NSError *error = nil;
    NSArray *fetchResults = [self.myApp.coreData.managedObjectContext executeFetchRequest:request error:&error];
    Landmark *lmark = ((Landmark *) [fetchResults objectAtIndex:0]);
    for (Intermediate *interm in lmark.intermediates) {
        if ([interm.index isEqualToString:self.rotation]) {
            self.landmarkImage.image = [self.myApp.lib getImageFromFile: interm.image];
            [self updatePopovers:interm];
            [self nextRotation];
            break;
        }
    }
}

/**
 * Fetch the popover information and update popovers.
 */
- (void) updatePopovers:(Intermediate *)interm {
    for (UIView* i in self.view.subviews){
        if ([i.class isSubclassOfClass:[IButton class]]) {
        [i removeFromSuperview];
        }
    }
    
    for (Popover* p in interm.popovers) {
        IButton *bt = [IButton buttonWithType:UIButtonTypeCustom];
        bt.title = p.title;
        bt.text = [self.myApp.lib getStringFromFile:p.text];
        bt.frame = CGRectMake(p.x.doubleValue, p.y.doubleValue, p.width.doubleValue, p.height.doubleValue);
        double r = (double)(arc4random()%255) / 255.0;
        double g = (double)(arc4random()%255) / 255.0;
        double b = (double)(arc4random()%255) / 255.0;
        bt.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:0.2];
        [bt addTarget:self action:@selector(popover:) forControlEvents:UIControlEventTouchUpInside];
        [bt addTarget:self action:@selector(glow:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:bt];
    }
}

- (void) popover:(IButton *)button {
    UITextView *text = [[UITextView alloc] init];
    text.frame = CGRectMake(0, 0, 450, 250);
    text.editable = NO;
    text.text = button.text;
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.frame = text.frame;
    vc.title = button.title;
    [vc.view addSubview:text];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    _popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    self.popover.popoverContentSize = vc.view.frame.size;
    [self.popover presentPopoverFromRect:CGRectMake(button.frame.size.width / 2, button.frame.size.height / 1, 1, 1) inView:button permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (void) glow:(IButton *)button {
    double r = (double)(arc4random()%255) / 255.0;
    double g = (double)(arc4random()%255) / 255.0;
    double b = (double)(arc4random()%255) / 255.0;
    button.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:0.3];
}

/**
 * Sets the direction of the next perspective of the landmark image to be viewed/fetched from core data for use when
 * the rotate view button is clicked again.
 * param: a string representing the current perspective of the landmark image being displayed
 */
-(void) nextRotation {
    if ([self.rotation isEqualToString:@"N"]) {
        self.rotation = @"E";
    }
    else if ([self.rotation isEqualToString:@"E"]) {
        self.rotation = @"S";
    }
    else if ([self.rotation isEqualToString:@"S"]) {
        self.rotation = @"W";
    }
    else {
        self.rotation = @"N";
    }
}

#pragma mark - play video

- (IBAction)playVideo:(id) sender{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *des = [NSEntityDescription entityForName:@"Landmark" inManagedObjectContext:self.myApp.coreData.managedObjectContext];
    [request setEntity: des];
    NSPredicate *query = [NSPredicate predicateWithFormat:@"landmark_name == %@", self.myApp.coreData.landmarkName];
    [request setPredicate:query];
    NSError *error = nil;
    NSArray *fetchResults = [self.myApp.coreData.managedObjectContext executeFetchRequest:request error:&error];
    Landmark *lmark = ((Landmark *) [fetchResults objectAtIndex:0]);

    [self initAndPlayVideo:lmark.landmark_video];
}


-(void) initAndPlayVideo:(NSString *)filename {
    NSString *path = [self.myApp.lib getResourceFilepath:filename];
    NSURL* url = [NSURL fileURLWithPath:path];
        MPMoviePlayerViewController* theMovie=[[MPMoviePlayerViewController alloc] initWithContentURL:url];
        if (theMovie) {
            [self presentMoviePlayerViewControllerAnimated:theMovie];
            theMovie.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playbackDidFinish:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:theMovie];
            [theMovie.moviePlayer play];
        }
}

- (void) playbackDidFinish:(NSNotification*)aNotification {
    MPMoviePlayerViewController* theMovie=[aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object: theMovie];
    [self dismissMoviePlayerViewControllerAnimated];
    [theMovie.moviePlayer stop];
    theMovie.moviePlayer.initialPlaybackTime=-1.0;
    theMovie = nil;
}

@end
