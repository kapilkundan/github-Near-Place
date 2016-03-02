//
//  ListOfPlacesTableViewController.h
//  Near By Place
//
//  Created by MAC23 on 01/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListOfPlacesTableViewController : UITableViewController
{
    NSMutableArray * listOfPlace;
    
}
@property (nonatomic,strong) NSString * typeOfPlace;
-(void)featchList:(NSString*)type;
@end
