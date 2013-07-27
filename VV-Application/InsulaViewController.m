//
//  InsulaViewController.m
//  VV-Application
//
//  Created by Nicholas Gordon on 10/8/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import "InsulaViewController.h"
#import "MapAnnotation.h"

@interface InsulaViewController ()

@end

@implementation InsulaViewController

@synthesize tableData;
@synthesize IVMapView;
@synthesize IVSummary;
@synthesize IVButton;
@synthesize IVSearchBar;
@synthesize IVSlider;
@synthesize IVTableView;
@synthesize landmarkImage;
@synthesize dates;
@synthesize myApp = _myApp;
@synthesize sliderDates;
@synthesize IVGeneralImage = _IVGeneralImage;
@synthesize titleBar;

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
 * Additional set up of view. Specifically, initialize buttons, set up map, initialize map annotations,
 * initialize search bar, and disable time slider.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableButtons];
    [self plotMapAnnotations];
    [self setInitialMapRegion];
    [IVSlider setEnabled:NO];
    
    //prompt user for search bar input
    [IVSearchBar setPlaceholder:@"Search for a Landmark!"];
    [IVSearchBar placeholder];
    
    [IVTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
    [self tableView:IVTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] name: @"Equestrian Monument to Bartolommeo Colleoni"];
    titleBar.topItem.title = self.myApp.coreData.insulaName;
}

#pragma mark - fetch from core data utility method

/**
 * Utility method to fetch data from the application's core data schema. 
 * param: entity to retrieve and predicate for retrieval.
 * return: array containing the fetched data results.
 */
-(NSArray *) entity:(NSString *) entity predicate: (NSPredicate *) query {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *des = [NSEntityDescription entityForName:entity inManagedObjectContext:self.myApp.coreData.managedObjectContext];
    [request setEntity:des];
    [request setPredicate:query];
    NSError *error = nil;
    NSArray *fetchResults = [self.myApp.coreData.managedObjectContext executeFetchRequest:request error:&error];
    return fetchResults;
}

#pragma mark - Slider methods, TimeChange methods

/**
 * Set up time slider. This includes enabling the time slider and creating text labels to represent
 * the year slots on the slider. Additionally, it pulls up default data to be displayed.
 */
-(void) setUpSlider {
    [IVSlider setEnabled:YES];
    dates = [[NSMutableArray alloc] init];
    for (UILabel *year in sliderDates) {
        [year removeFromSuperview];
    }
    
    sliderDates = [[NSMutableArray alloc] init];
        
    NSPredicate *query = [NSPredicate predicateWithFormat:@"landmark_name = %@", self.myApp.coreData.landmarkName];
    NSArray *fetchResults = [self entity:@"Landmark" predicate: query];
    Landmark *lmark = ((Landmark *) [fetchResults objectAtIndex:0]);
    
    // Set landmark general image
    self.IVGeneralImage.image = [self.myApp.lib getImageFromFile:lmark.landmark_general_picture];
    
    /* Need to handle the case when no timeslot found! */
    if (lmark.timeslots == NULL || lmark.timeslots.count == 0) {
        return;
    }
    
    for (Timeslot *slot in lmark.timeslots) {
        [dates addObject:slot.year];
    }
    IVSlider.continuous = YES;
    [IVSlider setMinimumValue:0];
    [IVSlider setMaximumValue:((float)[dates count] - 1)];
    
    int width = IVSlider.frame.size.width;
    //origin is top left of slider
    int startx = IVSlider.frame.origin.x;
    int starty = IVSlider.frame.origin.y;
    int count = 0;
    [dates sortUsingSelector:@selector(compare:)];
    for (NSNumber *num in dates) {
        UILabel *label;
        if ([dates count] > 1) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(startx + count * (width/([dates count]-1)) - 20, starty - 20, 40, 20) ];
        }
        else {
            label = [[UILabel alloc] initWithFrame:CGRectMake(startx + count * width - 20, starty - 20, 40, 20)];
        }
        [sliderDates addObject:label];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = self.view.backgroundColor;
        label.font = [UIFont fontWithName:@"Times New Roman Bold" size:(12.0)];
        [self.view addSubview:label];
        label.text = [NSString stringWithFormat: @"%d", [num intValue]];
        count++;
    }
    [IVSlider setValue:IVSlider.minimumValue];
    [IVSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self valueChanged:IVSlider];
}

/**
 * Updates data that gets displayed in the view i.e. text displayed in IVSummary and the image displayed in landmarkImage 
 * when the time slider value changes.
 * param: a UISlider, i.e. the time slider (IVSlider)
 */

-(void) valueChanged:(UISlider *) sender {
    NSUInteger index = (NSUInteger)(IVSlider.value + 0.5); //round number
    [IVSlider setValue:index animated:NO];
    NSNumber *date = [dates objectAtIndex:index];
    NSPredicate *query = [NSPredicate predicateWithFormat:@"landmark_name = %@", self.myApp.coreData.landmarkName];
    NSArray *fetchResults = [self entity:@"Landmark" predicate:query];
    Landmark *lmark = ((Landmark *) [fetchResults objectAtIndex:0]);
    for (Timeslot *timeslot in lmark.timeslots) {
        if ([timeslot.year isEqualToNumber:date]) {
            [IVSummary setText:[self.myApp.lib getStringFromFile:timeslot.landmark_general_description]];
            UIImage *img = [self.myApp.lib getImageFromFile:timeslot.landmark_general_picture];
            [landmarkImage setImage:img];
            break;
        };
    }
}

#pragma mark - TableView Data Source methods

/**
 * Retrieve names of all landmarks in the currently viewed insula and load them into tableData
 */
-(void) initTableButtons {
    tableData = [self entity:@"Landmark" predicate: nil];
}
/**
 * Retrieve number of landmarks buttons that must be created i.e. return the number of landmarks for the currently viewed 
 * insula
 * param: the table view and the number of rows for a given section of the view.
 * return: NSInteger representing the number of landmarks
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

/**
 * Create table cells which serve as landmark buttons in the insula view.
 * param: the table view for which we want to add cells and the index path for the newly created cell.
 * return: UITableViewCell representing a landmark.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell 1"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"Cell 1"];
    }
    cell.textLabel.text = [[tableData objectAtIndex:indexPath.row] landmark_name];
    return cell;
}

/**
 * Sets up the time slider, updates IVButton, and zooms on a landmark in the map when an landmark button is selected in
 * the table view.
 * param: the table view to monitor and the index path of the selected cell.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        NSString *name =[tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        self.myApp.coreData.landmarkName = name;
        [self setUpSlider];
        [IVButton setTitle: name forState: UIControlStateNormal];
        [IVButton sizeToFit];
        int position = 1012 - IVButton.frame.size.width;
        CGRect newFrame = CGRectMake(position, IVButton.frame.origin.y, IVButton.frame.size.width, IVButton.frame.size.height);
        [IVButton setFrame: newFrame];
        [self zoomOnAnnotation: name];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath name: (NSString *) name {
    self.myApp.coreData.landmarkName = name;
    [self setUpSlider];
    [IVButton setTitle: name forState: UIControlStateNormal];
    [IVButton sizeToFit];
    int position = 1012 - IVButton.frame.size.width;
    CGRect newFrame = CGRectMake(position, IVButton.frame.origin.y, IVButton.frame.size.width, IVButton.frame.size.height);
    [IVButton setFrame: newFrame];
    [self zoomOnAnnotation: name];
}

#pragma mark - Map Methods

/*
 * Fetches the names of all landmarks in the currently viewed insula and plots annotations on the map for each landmark
 */
-(void) plotMapAnnotations {
    // NSLog(@"plotting map annotations insula");
    NSPredicate *query = [NSPredicate predicateWithFormat:@"insula_name == %@", self.myApp.coreData.insulaName];
    NSArray *fetchResults = [self entity:@"Landmark" predicate:query];
    Landmark *lmark;
    for (lmark in fetchResults) {
        [self plotMapAnnotation:lmark.landmark_name address:[self.myApp.lib getStringFromFile:lmark.landmark_annotation_description] latitude:lmark.latitude.doubleValue longitude:lmark.longitude.doubleValue];
    }
}

/*
 * Plots a single annotation on the map
 * param: String representing the title of the annotation, string representing the address/description of the annotation, 
 * and the latitude and longitude at which the annotation should be plotted on the map.
 */
-(void) plotMapAnnotation: (NSString *) name address:(NSString *) address latitude:(double) latitude longitude:(double) longitude {
    MapAnnotation *annotation = [[MapAnnotation alloc] initWithName:name address:address latitude:latitude longitude:longitude];
    [IVMapView addAnnotation:annotation];
}

/**
 * Sets the initial region of the map to display. 
 */
-(void)setInitialMapRegion {
    MKCoordinateRegion mapRegion;
    mapRegion.center.latitude = 45.4333;
    mapRegion.center.longitude = 12.3167;
    mapRegion.span.latitudeDelta = 0.035;
    mapRegion.span.longitudeDelta = 0.035;
    [IVMapView setRegion:mapRegion animated: YES];
}

/**
 * Zooms in on a given annotation in the map.
 * param: a string representing the title of the annotation to zoom in on.
 */
-(void) zoomOnAnnotation: (NSString *) name {
    for  (MapAnnotation *annotation in IVMapView.annotations) {
        NSString *title = [annotation title];
        if ([title isEqualToString: name]) {
            //TODO: MAKE SURE NAME NOT EQUAL TO "Current Location"!
            MKCoordinateRegion mapRegion;
            mapRegion.center.latitude = annotation.coordinate.latitude;
            mapRegion.center.longitude = annotation.coordinate.longitude;
            mapRegion.span.latitudeDelta = 0.0005;
            mapRegion.span.longitudeDelta = 0.0005;
            [IVSlider setValue: 0.0005/0.1];
            [IVMapView setRegion:mapRegion animated: YES];
            MKPinAnnotationView *av = (MKPinAnnotationView *)[IVMapView viewForAnnotation:annotation];
            [av setPinColor:MKPinAnnotationColorGreen];
        }
        else if (![title isEqualToString:@"Current Location"]){
            MKPinAnnotationView *av = (MKPinAnnotationView *)[IVMapView viewForAnnotation:annotation];
            [av setPinColor:MKPinAnnotationColorRed];
        }
    }
}

#pragma mark - Search Bar Action

/**
 * Sets up the slider, shows description, and zooms in on the annotation for the searched landmark
 * Function equivalent to clicking a landmark button, however, is called when user inputs text into the search bar.
 */
-(IBAction)landmarkSearch: (UIBarButtonItem *)sender {
    for (MapAnnotation *annotation in IVMapView.annotations) {
        NSString *name = [annotation title];
        if ([name isEqualToString: IVSearchBar.text]) {
            [IVButton setTitle: IVSearchBar.text forState: UIControlStateNormal];
            [IVButton sizeToFit];
            int position = 1012 - IVButton.frame.size.width;
            CGRect newFrame = CGRectMake(position, IVButton.frame.origin.y, IVButton.frame.size.width, IVButton.frame.size.height);
            [IVButton setFrame: newFrame];
            self.myApp.coreData.landmarkName = IVSearchBar.text;
            [self setUpSlider];
            //NSPredicate *query = [NSPredicate predicateWithFormat:@"landmark_name == %@", name];
            //NSArray *fetchResults = [self entity:@"Landmark" predicate:query];
            //TODO: check if results is null
            //NSString* description = ((Landmark *)[fetchResults objectAtIndex:0]).landmark_general_description;
            //[IVSummary setText: [self.myApp.lib getStringFromFile:description]];
            [self zoomOnAnnotation: IVSearchBar.text];
        }
    }
}

#pragma mark - Other

/**
 * Function to implement actions to be taken if application memory limit is reached.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
