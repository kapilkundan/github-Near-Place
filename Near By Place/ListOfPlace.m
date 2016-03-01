//
//  ListOfPlace.m
//  Near By Place
//
//  Created by MAC23 on 01/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import "ListOfPlace.h"
#import "Constant.pch"
#import "LocationManager.h"
#import "Place.h"
@implementation ListOfPlace
- (void)listOfPlaceForType:(NSString*)type afterComplition:(void (^)(NSArray *listOfPlaces))finishBlock;
{
        self.completeQueryForPlace = finishBlock;
    CLLocation * location = [LocationManager sharedInstance].currentLocation;
   
    NSString *placeUrl =
    [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=1000&types=%@&key=%@",location.coordinate.latitude,location.coordinate.longitude,type,kGOOGLEAPI_KEY];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:placeUrl]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                   NSError* errorData;
                // handle response
                               NSDictionary* json = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:kNilOptions
                                      error:&errorData];
                
                //The results from Google will be an array obtained from the NSDictionary object with the key "results".
                NSArray* places = [json objectForKey:@"results"];
              //  self.completeQueryForPlace(places);
                //Write out the data to the console.
                
                NSMutableArray *groups = [[NSMutableArray alloc] init];
                
                NSArray *results1 = [json valueForKey:@"results"];
                NSLog(@"Count %d", results1.count);
                
                for (NSDictionary *groupDic in results1) {
                    Place *place = [[Place alloc] init];
                    
                    for (NSString *key in groupDic) {
                        if ([place respondsToSelector:NSSelectorFromString(key)]) {
                            [place setValue:[groupDic valueForKey:key] forKey:key];
                        }
                    }
                    
                    [groups addObject:place];
                }
                
                self.completeQueryForPlace(groups);
                NSLog(@"Google Data: %@ ", places);
            }] resume];
}


@end
