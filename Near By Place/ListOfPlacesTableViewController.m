//
//  ListOfPlacesTableViewController.m
//  Near By Place
//
//  Created by MAC23 on 01/03/16.
//  Copyright © 2016 Kapil Malviya. All rights reserved.
//

#import "ListOfPlacesTableViewController.h"
#import "ListOfPlace.h"
#import "Place.h"
#import "UIImage+ImageAsync.h"
#import "PlaceDetailViewController.h"
@interface ListOfPlacesTableViewController ()
{

UIRefreshControl *refreshControl;
}
@end

@implementation ListOfPlacesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    listOfPlace =  [[NSMutableArray alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(featchList:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated
{

    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    [self.refreshControl beginRefreshing];
}
-(void)featchList:(NSString *)type
{
    

ListOfPlace *listOfPlaceModel = [ListOfPlace new];
    [self.refreshControl beginRefreshing ];
  [listOfPlaceModel listOfPlaceForType:self.typeOfPlace afterComplition:^(NSArray *list,NSError *error){
      if (error) {
          
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Near By Place" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
          [alert show];
      }
      else
      {
          listOfPlace = [list mutableCopy];
          [self.tableView reloadData];
      }
      
   //   [MBProgressHUD hideHUDForView:self.view animated:YES];
  [self.refreshControl endRefreshing];
  } ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return listOfPlace.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *label = [cell viewWithTag:102];
    Place * place  =  (Place*)listOfPlace[indexPath.row];
    label.text = place.name;
    UIImageView *icon = [cell viewWithTag:101];
    if (!place.imageIcon) {
        [UIImage loadFromURL:[NSURL URLWithString:place.icon] callback:^(UIImage *image) {
            icon.image = image;
            place.imageIcon = image;

            [listOfPlace replaceObjectAtIndex:indexPath.row withObject:place];
        }];
    }
    else{
        icon.image = place.imageIcon;

    }
  
    // Configure the cell...
    
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
    
    if ([segue.identifier isEqualToString:@"PlaceDetailViewController"]) {
        PlaceDetailViewController * detailViewController = segue.destinationViewController;
          NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        detailViewController.placeDetail = listOfPlace[path.row];
    }
}


@end
