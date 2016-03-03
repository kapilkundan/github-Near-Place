//
//  FavoritesPlace.m
//  Near By Place
//
//  Created by MAC23 on 03/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import "FavoritesPlace.h"
#import "DbAccess.h"
@implementation FavoritesPlace
+(void) addFavoritPlace:(Place*) place
{

    NSString *query = [NSString stringWithFormat:@"insert into favourites values('%@', '%@', '%@', '%@','%@','%@')", place.name,place.keyId,place.icon,place.reference,place.place_id,place.vicinity];
    [DbAccess insertWithSQL:query];
}
+(void) deleteFavoritePlace:(Place*)place
{
    NSString *query = [NSString stringWithFormat:@"delete from favourites  where keyId ='%@'", place.keyId];
    [DbAccess deleteWithSQL:query];
}
+(NSArray*) selectFavoritePlace
{
    NSString *query = @"select * from favourites";
   return  [DbAccess selectManyRowsWithSQL:query];
}

@end
