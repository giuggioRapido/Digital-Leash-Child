//
//  ViewController.h
//  Child app
//
//  Created by Chris on 6/24/15.
//  Copyright (c) 2015 chuppy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, NSURLConnectionDataDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userID;
@property NSString *longitude, *latitude;
@property (strong, nonatomic)    NSMutableData *_responseData;


- (IBAction)submitButtonPressed:(id)sender;

@end

