//
//  TJY_InfomationTableViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/7.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_InfomationTableViewController.h"
#import "TJY_DatePickerViewController.h"
#import "TJY_Nation.h"
#import "TJY_NationViewController.h"
#import "TJY_CustomerViewModel.h"
@interface TJY_InfomationTableViewController ()

@end

@implementation TJY_InfomationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self  configUI];
}
-(void)configUI{
  
    NSArray *  array = @[self.phoneTF,self.nameTF,self.idCardTF,self.interestTF,self.addressTF,self.workPlaceTF,self.positionTF,self.clubCardTF,self.introduceTF,self.contactTF,self.buyStatusTF];
    NSArray *  vmArray = @[@"telphone",@"name",@"idCard",@"favourite",@"address",@"company",@"position",@"vipCard",@"introduce",@"conect",@"buyStatus"];
      @weakify(self);
    [array  enumerateObjectsUsingBlock:^(UITextField * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [self  textFieldPlaceholderColorWithTextField:obj];
        [obj.rac_textSignal  subscribeNext:^(NSString * _Nullable x) {
            [self.viewModel  setValue:x forKey:vmArray[idx] ];
        }];
    }];
    RACChannelTerminal  * segChannel = [self.sexSegment rac_newSelectedSegmentIndexChannelWithNilValue:0];
    
    [segChannel  subscribeNext:^(id  _Nullable x) {
          @strongify(self);
        self.viewModel.sex = [NSString  stringWithFormat:@"%@",x];
    }];
    
    RACChannelTerminal  *  stateChannel = [self.stateSegment  rac_newSelectedSegmentIndexChannelWithNilValue:0];
    [stateChannel    subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.viewModel.status = [NSString  stringWithFormat:@"%ld",[x integerValue] +1];
    }];
    
    RACChannelTerminal  *  marriageChannerl = [self.marriageTF  rac_newSelectedSegmentIndexChannelWithNilValue:0];
    [marriageChannerl  subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.viewModel.marryStatus = [NSString  stringWithFormat:@"%ld",[x integerValue] +1];
    }];
    
    RACChannelTerminal  * workChannel = [self.workStateSegment rac_newSelectedSegmentIndexChannelWithNilValue:0];
    [workChannel  subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.viewModel.workStatus =[NSString  stringWithFormat:@"%ld",[x integerValue] +1];
    }];
    
    RACChannelTerminal  *  sourceChannel = [self.sourceTF  rac_newSelectedSegmentIndexChannelWithNilValue:0];
    [sourceChannel  subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.viewModel.sourceFrom = [NSString  stringWithFormat:@"%ld",[x integerValue] +1];
    }];
    
}
-(void)textFieldPlaceholderColorWithTextField:(UITextField*)textField{
    [textField  setValue:ssRGBHex(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [super  numberOfSectionsInTableView:tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [super  tableView:tableView numberOfRowsInSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1&&indexPath.row==1) {
        TJY_DatePickerViewController  *  picker = [[UIStoryboard  storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TJY_DatePickerViewController"];
        picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        @weakify(self);
        picker.dateBlock = ^(NSString *dateString) {
            @strongify(self);
            self.birthdayLbl.text =  dateString;
            self.birthdayLbl.textColor =   ssRGBHex(0x222222);
            self.viewModel.birthday = dateString;
        };
        [self.tabBarController presentViewController:picker animated:YES completion:nil];
    }
}
-(void)viewDidLayoutSubviews {
    [super  viewDidLayoutSubviews];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
//    return cell;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
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
#pragma mark -- getter method
-(TJY_CustomerViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[TJY_CustomerViewModel alloc] init];
    }
    return  _viewModel;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"TJY_NationViewController"] &&[segue.destinationViewController  isKindOfClass:[TJY_NationViewController class]]) {
        TJY_NationViewController  *  vc = segue.destinationViewController;
        @weakify(self);
        vc.backValueBlock = ^(TJY_Nation *model) {
            @strongify(self);
            self.nationLbl.text = model.nation;
            self.nationLbl.textColor = ssRGBHex(0x222222);
            self.nationId = model.Id;
            self.viewModel.nation = model.Id;
        };
    }
}


@end
