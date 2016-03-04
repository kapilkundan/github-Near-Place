//
//  AppCache.m
//  Near By Place
//
//  Created by MAC23 on 04/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import "AppCache.h"

@implementation AppCache
+(AppCache*)sharedInstance
{
    static AppCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;

}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.appImageCache = [[NSCache alloc] init];
    }
    return self;
}
-(void)cacheAppImage:(UIImage *)image forKey:(NSString *)key {
    [self.appImageCache setObject:image forKey:key];
}

- (UIImage*)getAppCachedImageForKey:(NSString *)key{
    return [self.appImageCache objectForKey:key];
}

@end
