//
//  PlaceDetailViewController.m
//  Near By Place
//
//  Created by MAC23 on 01/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import "UIImage+ImageAsync.h"
#import "ViewController.h"
#import "FavoritesPlace.h"
@interface PlaceDetailViewController ()

@end

@implementation PlaceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem * bookMarkButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(favorites:)];
    self.navigationItem.rightBarButtonItem = bookMarkButton;
    
}

-(void)favorites:(id)sender
{
    [FavoritesPlace addFavoritPlace:self.placeDetail];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setValueOnScreen];
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
    self.detail.text  = self.placeDetail.vicinity;
    NSLog(@"image Refreance : \n %@ ",[NSString stringWithFormat:REREANCIMAGEURL,self.placeDetail.photo_reference,kGOOGLEAPI_KEY]);
    if (self.placeDetail.photo_reference) {
        [MBProgressHUD showHUDAddedTo:self.image animated:YES];
        [UIImage loadFromURL:[NSURL URLWithString:[NSString stringWithFormat:REREANCIMAGEURL,self.placeDetail.photo_reference,kGOOGLEAPI_KEY] ]callback:^(UIImage *image){
            if (image) {
                self.image.image   = image;
            }
            else
            {
                [self imageNotFound];
            }
            [MBProgressHUD hideHUDForView:self.image animated:YES];
            
        } ];
    }
    else
    {
        [self imageNotFound];

    }
 
}
-(void)imageNotFound
{

    self.image.backgroundColor = [UIColor blackColor];
    UILabel *notFound = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    notFound.text = @"Image not Found ";
    notFound.textColor = [UIColor whiteColor];
    //  notFound.frame = CGRectMake(self.image.frame.size.width/2, self.image.frame.size.height/2, notFound.frame.size.width, notFound.frame.size.height);
    [self.image addSubview: notFound];
}
@end
