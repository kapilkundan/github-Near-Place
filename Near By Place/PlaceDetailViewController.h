//
//  PlaceDetailViewController.h
//  Near By Place
//
//  Created by MAC23 on 01/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "Place.h"
@interface PlaceDetailViewController : UIViewController
@property (nonatomic,strong) IBOutlet  UILabel *name;
@property (nonatomic,strong) IBOutlet UILabel *detail;
@property (nonatomic,strong) IBOutlet UIImageView *image;
@property(nonatomic,strong) Place * placeDetail;
-(void)setValueOnScreen;

@end
