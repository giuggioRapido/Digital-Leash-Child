//
//  ViewController.m
//  Child app
//
//  Created by Chris on 6/24/15.
//  Copyright (c) 2015 chuppy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    CLLocationManager *locationManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* LocationManager stuffs */
    locationManager = [[CLLocationManager alloc]init];
    [locationManager requestAlwaysAuthorization];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonPressed:(id)sender {
    
    /* If username text field is empty, show alert. Else, do rest. */
    if(_userID.text.length == 0) {
        UIAlertView *emptyFieldAlert =
        [[UIAlertView alloc]initWithTitle:@"Please enter a username" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [emptyFieldAlert show];
    } else {
        NSDictionary *childDict = @{@"utf8": @"✓",@"authenticity_token":@"EvZva3cKnzo3Y0G5R3NktucCr99o/2UWOPVAmJYdBOc=",
                                    @"user":@{@"username":self.userID.text,@"current_lat":self.latitude,@"current_longitude":self.longitude},
                                    @"commit":@"Create User", @"action":@"update", @"controller":@"users"};
        
        /* Convert NSDictionary to JSON */
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:childDict options:NSJSONWritingPrettyPrinted error:nil];
        
        /* Create mutable string for URL */
        NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"http://protected-wildwood-8664.herokuapp.com/users/"];
        [url appendString:self.userID.text];
        [url appendFormat:@".json"];
        
        /* Create PATCH request */
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"PATCH"];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        /* Create connection */
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *) manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert =
    [[UIAlertView alloc]initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
        _longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}


#pragma mark - NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Connection Initialized");
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"I got a piece of data!");
    NSLog(@"Adding it to _responseData");
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"I'm done getting all the data!");
    NSLog(@"You can find it in _responseData");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Something went wrong!");
    NSLog(@"%@", error.localizedDescription);
    
    /* Create UIAlert for failed connection */
    UIAlertView *failedConnectionAlert =
    [[UIAlertView alloc]initWithTitle:@"Connection Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [failedConnectionAlert show];
}

@end
