//
//  ListOfPlace.h
//  Near By Place
//
//  Created by MAC23 on 01/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ComplitionQuery)(NSArray *listOfPlaces);
@interface ListOfPlace : NSObject
- (void)listOfPlaceForType:(NSString*)type afterComplition:(void (^)(NSArray *listOfPlaces))finishBlock;
@property (copy, nonatomic) ComplitionQuery completeQueryForPlace;
@end
