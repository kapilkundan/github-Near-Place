//
//  Place.h
//  Near By Place
//
//  Created by MAC23 on 01/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Place : NSObject
@property (strong, nonatomic) NSString* vicinity;
@property (strong, nonatomic) NSString* icon;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* place_id;
@property (strong, nonatomic) NSString* geometry;
@property (strong, nonatomic) NSString* rating;
@property (strong, nonatomic) NSString* reference;
@property (strong, nonatomic) NSString* scope;
@property (strong, nonatomic) NSString* types;
@property (strong, nonatomic) NSString* keyId;
@property (strong, nonatomic) NSString* photo_reference;
@property (strong,nonatomic) UIImage *imageIcon;
@end
