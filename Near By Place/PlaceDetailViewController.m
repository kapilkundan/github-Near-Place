//
//  PlaceDetailViewController.m
//  Near By Place
//
//  Created by MAC23 on 01/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import "UIImage+ImageAsync.h"
@interface PlaceDetailViewController ()

@end

@implementation PlaceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setValueOnScreen
{
    self.name.text  = self.placeDetail.name;
    self.detail.text  = self.placeDetail.reference;
    [UIImage loadFromURL:[NSURL URLWithString:self.placeDetail.icon] callback:^(UIImage *image){
        self.image.image   = image;
    } ];
}
@end
