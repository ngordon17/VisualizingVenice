//
//  InsulaViewController.h
//  VV-Application
//
//  Created by Nicholas Gordon on 10/8/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>
#import "HomescreenViewController.h"
#import "AppDelegate.h"

@interface InsulaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *tableData;
}

@property (nonatomic, retain) NSArray *tableData;
@property(nonatomic, weak) IBOutlet UITextView *IVSummary;
@property(nonatomic, weak) IBOutlet UIButton *IVButton;
@property(nonatomic, weak) IBOutlet MKMapView *IVMapView;
@property(nonatomic, weak) IBOutlet UISearchBar *IVSearchBar;
@property(nonatomic, weak) IBOutlet UISlider *IVSlider;
@property(nonatomic, weak) IBOutlet UIImageView *landmarkImage;
@property(nonatomic, weak) IBOutlet UITableView *IVTableView;
@property(nonatomic, weak) IBOutlet UIImageView *IVGeneralImage;
@property(nonatomic, strong) NSMutableArray *dates;
@property(nonatomic, weak) AppDelegate *myApp;
@property(nonatomic, strong) NSMutableArray *sliderDates;
@property(nonatomic, strong) IBOutlet UINavigationBar *titleBar;


/**
 * Additional set up of view. Specifically, initialize buttons, set up map, initialize map annotations,
 * initialize search bar, and disable time slider.
 */
-(void)viewDidLoad;

/**
 * Utility method to fetch data from the application's core data schema.
 * param: entity to retrieve and predicate for retrieval.
 * return: array containing the fetched data results.
 */
-(NSArray *) entity:(NSString *) entity predicate: (NSPredicate *) query;

/**
 * Set up time slider. This includes enabling the time slider and creating text labels to represent
 * the year slots on the slider. Additionally, it pulls up default data to be displayed.
 */
-(void) setUpSlider;

/**
 * Updates data that gets displayed in the view i.e. text displayed in IVSummary and the image displayed in landmarkImage
 * when the time slider value changes.
 * param: a UISlider, i.e. the time slider (IVSlider)
 */
-(void) valueChanged:(UISlider *) sender;

/**
 * Retrieve names of all landmarks in the currently viewed insula and load them into tableData
 */
-(void)initTableButtons;

/**
 * Retrieve number of landmarks buttons that must be created i.e. return the number of landmarks for the currently viewed
 * insula
 * param: the table view and the number of rows for a given section of the view.
 * return: NSInteger representing the number of landmarks
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

/**
 * Create table cells which serve as landmark buttons in the insula view.
 * param: the table view for which we want to add cells and the index path for the newly created cell.
 * return: UITableViewCell representing a landmark.
 */

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Sets up the time slider, updates IVButton, and zooms on a landmark in the map when an landmark button is selected in
 * the table view.
 * param: the table view to monitor and the index path of the selected cell.
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/*
 * Fetches the names of all landmarks in the currently viewed insula and plots annotations on the map for each landmark
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
 * Sets up the slider, shows description, and zooms in on the annotation for the searched landmark
 * Function equivalent to clicking a landmark button, however, is called when user inputs text into the search bar.
 */
-(IBAction)landmarkSearch: (UIBarButtonItem *)sender;

/**
 * Function to implement actions to be taken if application memory limit is reached.
 */
-(void)didReceiveMemoryWarning;


@end
