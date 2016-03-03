//
//  TypeOfPlaceTableViewController.m
//  Near By Place
//
//  Created by MAC23 on 01/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import "TypeOfPlaceTableViewController.h"
#import "TypeOfPlace.h"
#import "FavoritesTableViewController.h"
#import "ListOfPlacesTableViewController.h"
#import "UIView+Gradient.h"
@interface TypeOfPlaceTableViewController ()

@end

@implementation TypeOfPlaceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    listOfPlaces = [[NSArray alloc] initWithArray:[TypeOfPlace getTypeOfPlace]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  //  UIBarButtonItem * rightItemButton = [[UIBarButtonItem alloc] initWithTitle:@"Favorites" style:UIBarButtonItemStyleDone target:self action:@selector(showFavorites:)];
   // self.navigationItem.rightBarButtonItem = rightItemButton;
}

/*
-(void)showFavorites:(id)sender
{

    UIStoryboard *stroryBoard = MainStoryBoard;
    FavoritesTableViewController * favortiesPlaceViewController = [stroryBoard instantiateViewControllerWithIdentifier:@"FavoritesTableViewController"];
    [self presentViewController:favortiesPlaceViewController animated:YES completion:nil];
}*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listOfPlaces.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *text  = listOfPlaces[indexPath.row];
    cell.textLabel.text  = text.capitalizedString;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier  isEqualToString: @"ListOfPlacesTableViewController"] ) {
        ListOfPlacesTableViewController * listOfPlaceController = (ListOfPlacesTableViewController*) [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        listOfPlaceController.typeOfPlace = [listOfPlaces objectAtIndex:path.row];
        [listOfPlaceController featchList:[listOfPlaces objectAtIndex:path.row]];
    }

}


@end
