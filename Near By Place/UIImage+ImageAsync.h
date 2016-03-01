//
//  UIImage+ImageAsync.h
//  Near By Place
//
//  Created by MAC23 on 01/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageAsync)
+ (void) loadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback ;

@end
