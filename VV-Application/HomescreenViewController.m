//
//  ViewController.m
//  VV-Application
//
//  Created by Nicholas Gordon on 10/5/12.
//  Copyright (c) 2012 Nicholas Gordon. All rights reserved.
//

#import "HomescreenViewController.h"
#import "MapAnnotation.h"
#import "Insula.h"


@interface HomescreenViewController ()

@end


//TODO: find better design solution to this global variable.....

@implementation HomescreenViewController;
@synthesize tableData;
@synthesize HSSummary;
@synthesize HSButton;
@synthesize HSMapView;
@synthesize HSSearchBar;
@synthesize HSSlider;
@synthesize insulaImage;
@synthesize myApp = _myApp;
@synthesize HSTableView;
@synthesize dates;
@synthesize HSGeneralImage = _HSGeneralImage;

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
 * Additional set up of view. Specifically, initialize insula buttons, plot map annotations, set the initial map region, 
 * disable the HSSlider, and set the prompt for the search bar.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableButtons];
    [self plotMapAnnotations];
    [self setInitialMapRegion];
    [HSSlider setEnabled:NO];
    [HSSearchBar setPlaceholder:@"Search for an Insula!"];
    [HSSearchBar placeholder];
    [HSTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
    [self tableView:HSTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] name: @"Gesuiti"];
}

#pragma mark - fetch from core data utility method

/** 
 * Utility method to fetch data from core data. 
 * param: String representing entity to fetch and a predicate representing the query to core data.
 * return: an array (fetchResults) representing the results of the fetch from core data.
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
 * Set up the time slider. Specifically, create labels from time sots, enable the slider, fetch time slots dats from core 
 * data, and set default, min, and max values for time slider.
 */
-(void) setUpSlider {
    [HSSlider setEnabled:YES];
    dates = [[NSMutableArray alloc] init];
    NSPredicate *query = [NSPredicate predicateWithFormat:@"insula_name = %@", self.myApp.coreData.insulaName];
    NSArray *fetchResults = [self entity:@"Insula" predicate: query];
    Insula *insula = ((Insula *) [fetchResults objectAtIndex:0]);
    
    // Set insula general image
    self.HSGeneralImage.image = [self.myApp.lib getImageFromFile:insula.insula_general_picture];
    
    for (Timeslot *slot in insula.timeslots) {
        [dates addObject:slot.year];
    }
    HSSlider.continuous = YES;
    [HSSlider setMinimumValue:0];
    [HSSlider setMaximumValue:((float)[dates count] - 1)];
    
    int width = HSSlider.frame.size.width;
    //origin is top left of slider
    int startx = HSSlider.frame.origin.x;
    int starty = HSSlider.frame.origin.y;
    int count = 0;
    [dates sortUsingSelector:@selector(compare:)];
    for (NSNumber *num in dates) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(startx + count * (width/([dates count]-1)) - 20, starty - 20, 40, 20) ];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = self.view.backgroundColor;
        label.font = [UIFont fontWithName:@"Times New Roman Bold" size:(12.0)];
        [self.view addSubview:label];
        label.text = [NSString stringWithFormat: @"%d", [num intValue]];
        count++;
    }
    [HSSlider setValue:HSSlider.maximumValue];
    [HSSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self valueChanged:HSSlider];
}

/**
 * Called when the user changes the value of the time slider. Based upon value pulls description for the specific time 
 * period as well as the image for the landmark during the given time period from core data and displays that data.
 * param: the time slider being monitored
 */
-(void) valueChanged:(UISlider *) sender {
    NSUInteger index = (NSUInteger)(HSSlider.value + 0.5); //round number
    [HSSlider setValue:index animated:NO];
    NSNumber *date = [dates objectAtIndex:index];
    NSPredicate *query = [NSPredicate predicateWithFormat:@"insula_name = %@", self.myApp.coreData.insulaName];
    NSArray *fetchResults = [self entity:@"Insula" predicate:query];
    Insula *insula = ((Insula *) [fetchResults objectAtIndex:0]);
    for (Timeslot *timeslot in insula.timeslots) {
        if ([timeslot.year isEqualToNumber:date]) {
            [HSSummary setText:[self.myApp.lib getStringFromFile:timeslot.insula_general_description]];
            UIImage *img = [self.myApp.lib getImageFromFile:timeslot.insula_general_picture];
            [insulaImage setImage:img];
            break;
        };
    }
}


#pragma mark - TableView Data Source methods

/**
 * Retrieve names of all insulas and load them into tableData
 */
-(void) initTableButtons {
    tableData = [self entity:@"Insula" predicate: nil];
}

/**
 * Retrieve number of insula buttons that must be created  
 * param: the table view and the number of rows for a given section of the view.
 * return: NSInteger representing the number of insulas
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

/**
 * Create table cells which serve as insula buttons in the insula view.
 * param: the table view for which we want to add cells and the index path for the newly created cell.
 * return: UITableViewCell representing an insula.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell 1"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"Cell 1"];
    }
    cell.textLabel.text = [[tableData objectAtIndex:indexPath.row] insula_name];
    return cell;
}

/**
 * Sets up the time slider, updates HSButton, and zooms on an insula in the map when an insula button is selected in
 * the table view.
 * param: the table view to monitor and the index path of the selected cell.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name =[tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    self.myApp.coreData.insulaName = name;
    [HSButton setTitle: name forState: UIControlStateNormal];
    [HSButton sizeToFit];
    int position = 1012 - HSButton.frame.size.width;
    CGRect newFrame = CGRectMake(position, HSButton.frame.origin.y, HSButton.frame.size.width, HSButton.frame.size.height);
    [HSButton setFrame: newFrame];
    [self zoomOnAnnotation: name];
    [self setUpSlider];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath name:(NSString *)name {
    self.myApp.coreData.insulaName = name;
    [HSButton setTitle: name forState: UIControlStateNormal];
    [HSButton sizeToFit];
    int position = 1012 - HSButton.frame.size.width;
    CGRect newFrame = CGRectMake(position, HSButton.frame.origin.y, HSButton.frame.size.width, HSButton.frame.size.height);
    [HSButton setFrame: newFrame];
    [self zoomOnAnnotation: name];
    [self setUpSlider];
}

#pragma mark - Map Methods

/*
 * Fetches the names of all insulas plots annotations on the map for each insula
 */
-(void) plotMapAnnotations {
    NSArray *fetchResults = [self entity:@"Insula" predicate:nil];
    Insula *insulaData;
    for (insulaData in fetchResults) {
        NSString *generalDes = [self.myApp.lib getStringFromFile:insulaData.insula_annotation_description];
        [self plotMapAnnotation:insulaData.insula_name address:generalDes latitude:insulaData.latitude.doubleValue longitude:insulaData.longitude.doubleValue];
    }
}

/*
 * Plots a single annotation on the map
 * param: String representing the title of the annotation, string representing the address/description of the annotation,
 * and the latitude and longitude at which the annotation should be plotted on the map.
 */
-(void) plotMapAnnotation: (NSString *) name address:(NSString *) address latitude:(double) latitude longitude:(double) longitude {
    MapAnnotation *annotation = [[MapAnnotation alloc] initWithName:name address:address latitude:latitude longitude:longitude];
    [HSMapView addAnnotation:annotation];
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
    [HSMapView setRegion:mapRegion animated: YES];
}

/**
 * Zooms in on a given annotation in the map.
 * param: a string representing the title of the annotation to zoom in on.
 */
-(void) zoomOnAnnotation: (NSString *) name {
    for  (MapAnnotation *annotation in HSMapView.annotations) {
        NSString *title = [annotation title];
        if ([title isEqualToString: name]) {
            //TODO: MAKE SURE NAME NOT EQUAL TO "Current Location"!
            MKCoordinateRegion mapRegion;
            mapRegion.center.latitude = annotation.coordinate.latitude;
            mapRegion.center.longitude = annotation.coordinate.longitude;
            mapRegion.span.latitudeDelta = 0.0005;
            mapRegion.span.longitudeDelta = 0.0005;
            [HSSlider setValue: 0.0005/0.1];
            [HSMapView setRegion:mapRegion animated: YES];
            MKPinAnnotationView *av = (MKPinAnnotationView *)[HSMapView viewForAnnotation:annotation];
            [av setPinColor:MKPinAnnotationColorGreen];
        }
        else if (![title isEqualToString:@"Current Location"]){
            MKPinAnnotationView *av = (MKPinAnnotationView *)[HSMapView viewForAnnotation:annotation];
            [av setPinColor:MKPinAnnotationColorRed];
        }
    }
}

#pragma mark - Search Bar Action

/**
 * Sets up the slider, shows description, and zooms in on the annotation for the searched insula
 * Function equivalent to clicking an insula button, however, is called when user inputs text into the search bar.
 */
-(IBAction)insulaSearch: (UIBarButtonItem *)sender {
    for (MapAnnotation *annotation in HSMapView.annotations) {
        NSString *name = [annotation title];
        if ([name isEqualToString: HSSearchBar.text]) {
            [HSButton setTitle: HSSearchBar.text forState: UIControlStateNormal];
            [HSButton sizeToFit];
            int position = 1012 - HSButton.frame.size.width;
            CGRect newFrame = CGRectMake(position, HSButton.frame.origin.y, HSButton.frame.size.width, HSButton.frame.size.height);
            [HSButton setFrame: newFrame];
            /*NSPredicate *query = [NSPredicate predicateWithFormat:@"insula_name == %@", name];
            NSArray *fetchResults = [self entity:@"Insula" predicate:query];
            //TODO: check if results is null
            NSString* description = ((Insula *)[fetchResults objectAtIndex:0]).insula_general_description;
            NSString* generalDes = [self.myApp.lib getStringFromFile:description];
            [HSSummary setText: generalDes];*/
            [self zoomOnAnnotation: HSSearchBar.text];
            self.myApp.coreData.insulaName = HSSearchBar.text;
            [self setUpSlider];
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
