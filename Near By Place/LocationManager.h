//
//  LocationManager.h
//  Near By Place
//
//  Created by MAC23 on 01/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface LocationManager : NSObject <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

+(LocationManager*)sharedInstance;
- (void)startUpdatingLocation;

@end
