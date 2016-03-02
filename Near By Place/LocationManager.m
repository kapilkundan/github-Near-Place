#import "LocationManager.h"

@implementation LocationManager

+(LocationManager *) sharedInstance
{
    static LocationManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if(self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 5000; // in meters
        self.locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager requestAlwaysAuthorization];
        }
            [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)startUpdatingLocation
{
    NSLog(@"Starting location updates");
    [self.locationManager startUpdatingLocation];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.userInfo);
    if(![CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
        }
    }
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray*)locations
{
    CLLocation *location = [locations lastObject];
    NSLog(@"Latitude %+.6f, Longitude %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude);
    self.currentLocation = location;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self startUpdatingLocation];


}



@end