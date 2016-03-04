//
//  ListOfPlace.m
//  Near By Place
//
//  Created by MAC23 on 01/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import "ListOfPlace.h"
#import "LocationManager.h"
#import "Place.h"
@implementation ListOfPlace
- (void)listOfPlaceForType:(NSString*)type afterComplition:(void (^)(NSArray *listOfPlaces,NSError *error))finishBlock;
{
        self.completeQueryForPlace = finishBlock;
    if ([[LocationManager sharedInstance] isLocationEnable]) {
        CLLocation * location = [LocationManager sharedInstance].currentLocation;
        
        NSString *placeUrl =
        [NSString stringWithFormat:PLACEURL,location.coordinate.latitude,location.coordinate.longitude,type,kGOOGLEAPI_KEY];
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:placeUrl]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    NSError* errorData;
                    
                    if (error) {
                        NSLog(@"dataTask error: %@", error);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            
                            self.completeQueryForPlace(@[],error);
                            
                            
                        });
                        return ;
                        
                    }
                    
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        
                        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                        
                        if (statusCode != 200) {
                            NSLog(@" HTTP status code: %d", statusCode);
                            
                        }
                    }
                    
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
                    
                    for (NSDictionary *groupDic in results1) {
                        Place *place = [[Place alloc] init];
                        
                        for (NSString *key in groupDic) {
                            if ([place respondsToSelector:NSSelectorFromString(key)]) {
                                [place setValue:[groupDic valueForKey:key] forKey:key];
                            }
                            else if ([key isEqualToString:@"id"])
                            {
                                [place setValue:[groupDic valueForKey:key] forKey:@"keyId"];
                            }
                            else if([key isEqualToString:@"photos"])
                            {
                                if ([[[groupDic valueForKey:key] valueForKey:@"photo_reference"] count]>0) {
                                    [place setValue:[[groupDic valueForKey:key] valueForKey:@"photo_reference"][0] forKey:@"photo_reference"];
                                }
                            
                            }
                        }
                        
                        [groups addObject:place];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        self.completeQueryForPlace(groups,error);
                        
                        
                    });
                    NSLog(@"Google Data: %@ ", places);
                }] resume];
    }
    else
        
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            self.completeQueryForPlace(@[],nil);
            
            
        });
    }
   
}


@end
