//
//  TJY_InfoListViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/13.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_InfoListViewController.h"
#import "TJY_HomePageViewModel.h"
#import "TJY_LoginCellHelper.h"
#import "TJY_RegistViewController.h"
@interface TJY_InfoListViewController ()
@property(nonatomic,strong) TJY_LoginCellHelper * helper;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TJY_InfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     TJY_HomePageViewModel  * model = [[TJY_HomePageViewModel  alloc] init];
     RACSignal  * source = [model.LoginInfoCommand  execute:nil];
     RACCommand *selectCommand=nil;
     selectCommand =[ [RACCommand  alloc] initWithSignalBlock:^RACSignal  *(RACTuple *turple) {
         if (self->_delegate &&[self->_delegate  respondsToSelector:@selector(popViewControllerWithTitel:Id:isdepartment:)]) {
            [self->_delegate  popViewControllerWithTitel:turple.first Id: turple.third isdepartment:[turple.second  boolValue]];
        }
        [self.navigationController popViewControllerAnimated:YES];
        return [RACSignal  empty];
    }];
     self.helper =    [ [TJY_LoginCellHelper  alloc]  initWithTableView:self.tableView sourceSignal:source selectionCommand:selectCommand customCellClass:[UITableViewCell class]];
    self.helper.isdepartment = self.isdepartment;
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

@end
