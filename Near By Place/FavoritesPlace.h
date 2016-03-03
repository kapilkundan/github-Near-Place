//
//  FavoritesPlace.h
//  Near By Place
//
//  Created by MAC23 on 03/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"
@interface FavoritesPlace : NSObject
+(void) addFavoritPlace:(Place*) place;
+(void) deleteFavoritePlace:(Place*)place;
+(NSArray*) selectFavoritePlace;
@end
