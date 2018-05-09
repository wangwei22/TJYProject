//
//  TJY_InfomationTableViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/7.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_InfomationTableViewController.h"

@interface TJY_InfomationTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stateSegment;
@property (weak, nonatomic) IBOutlet UITextField *idCardTF;
@property (weak, nonatomic) IBOutlet UITextField *interestTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *marriageTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *workStateSegment;
@property (weak, nonatomic) IBOutlet UITextField *workPlaceTF;
@property (weak, nonatomic) IBOutlet UITextField *positionTF;
@property (weak, nonatomic) IBOutlet UITextField *economicsTF;
@property (weak, nonatomic) IBOutlet UITextField *clubCardTF;
@property (weak, nonatomic) IBOutlet UITextField *introduceTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sourceTF;
@property (weak, nonatomic) IBOutlet UITextField *contactTF;
@property (weak, nonatomic) IBOutlet UITextField *buyStatusTF;
@end

@implementation TJY_InfomationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    switch (section) {
        case 0:
                return 4;
            break;
        case 1:
               return 6;
            break;
        case 2:
               return 4;
            break;
        default:
               return 5;
            break;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.001;
}
-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
