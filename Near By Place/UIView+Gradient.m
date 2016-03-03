//
//  UIView+Gradient.m
//  Near By Place
//
//  Created by MAC23 on 03/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import "UIView+Gradient.h"

@implementation UIView (Gradient)
-(void) addGradient:(NSArray *)stopColors
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = stopColors;
    gradient.startPoint = CGPointMake(0.5f, 0.0f);
    gradient.endPoint = CGPointMake(0.5f, 1.0f);
    [self.layer addSublayer:gradient];
}

@end
