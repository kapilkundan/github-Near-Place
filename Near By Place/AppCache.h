//
//  AppCache.h
//  Near By Place
//
//  Created by MAC23 on 04/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppCache : NSObject
@property (nonatomic, strong) NSCache *appImageCache;
// Set Image
- (void)cacheAppImage:(UIImage*)image forKey:(NSString*)key;
// Get image
- (UIImage*)getAppCachedImageForKey:(NSString*)key;
+(AppCache*)sharedInstance;
@end
