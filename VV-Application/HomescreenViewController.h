//
//  ViewController.h
//  VV-Application
//
//  Created by Nicholas Gordon on 10/5/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CoreData.h"
#import "AppDelegate.h"
#import "PublicLibrary.h"


@interface HomescreenViewController : UIViewController <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSArray *tableData;    
}

//TODO: find better design solution to global variables....

@property (nonatomic, retain) NSArray *tableData;
@property(nonatomic, weak) IBOutlet UITextView *HSSummary;
@property(nonatomic, weak) IBOutlet UIButton *HSButton;
@property(nonatomic, weak) IBOutlet UISearchBar *HSSearchBar;
@property(nonatomic, weak) IBOutlet MKMapView *HSMapView;
@property(nonatomic, weak) IBOutlet UISlider *HSSlider;
@property(nonatomic, weak) IBOutlet UIImageView *insulaImage;
@property(nonatomic, weak) IBOutlet UITableView *HSTableView;
@property(nonatomic, weak) IBOutlet UIImageView *HSGeneralImage;
@property(nonatomic, strong) NSMutableArray *dates;

@property(nonatomic, weak) AppDelegate *myApp;


/**
 * Additional set up of view. Specifically, initialize insula buttons, plot map annotations, set the initial map region,
 * disable the HSSlider, and set the prompt for the search bar.
 */
- (void)viewDidLoad;

/**
 * Utility method to fetch data from core data.
 * param: String representing entity to fetch and a predicate representing the query to core data.
 * return: an array (fetchResults) representing the results of the fetch from core data.
 */
-(NSArray *) entity:(NSString *) entity predicate: (NSPredicate *) query;

/**
 * Set up the time slider. Specifically, create labels from time sots, enable the slider, fetch time slots dats from core
 * data, and set default, min, and max values for time slider.
 */
-(void) setUpSlider;

/**
 * Called when the user changes the value of the time slider. Based upon value pulls description for the specific time
 * period as well as the image for the landmark during the given time period from core data and displays that data.
 * param: the time slider being monitored
 */
-(void) valueChanged:(UISlider *) sender;

/**
 * Retrieve names of all insulas and load them into tableData
 */
-(void) initTableButtons;

/**
 * Retrieve number of insula buttons that must be created
 * param: the table view and the number of rows for a given section of the view.
 * return: NSInteger representing the number of insulas
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

/**
 * Create table cells which serve as insula buttons in the insula view.
 * param: the table view for which we want to add cells and the index path for the newly created cell.
 * return: UITableViewCell representing an insula.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Sets up the time slider, updates HSButton, and zooms on an insula in the map when an insula button is selected in
 * the table view.
 * param: the table view to monitor and the index path of the selected cell.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/*
 * Fetches the names of all insulas plots annotations on the map for each insula
 */
-(void) plotMapAnnotations;

/*
 * Plots a single annotation on the map
 * param: String representing the title of the annotation, string representing the address/description of the annotation,
 * and the latitude and longitude at which the annotation should be plotted on the map.
 */
-(void) plotMapAnnotation: (NSString *) name address:(NSString *) address latitude:(double) latitude longitude:(double) longitude;

/**
 * Sets the initial region of the map to display.
 */
-(void)setInitialMapRegion;

/**
 * Zooms in on a given annotation in the map.
 * param: a string representing the title of the annotation to zoom in on.
 */
-(void) zoomOnAnnotation: (NSString *) name;

/**
 * Sets up the slider, shows description, and zooms in on the annotation for the searched insula
 * Function equivalent to clicking an insula button, however, is called when user inputs text into the search bar.
 */
-(IBAction)insulaSearch: (UIBarButtonItem *)sender;

/**
 * Function to implement actions to be taken if application memory limit is reached.
 */
- (void)didReceiveMemoryWarning;



@end
