//
//  TJY_MyStatisticsViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/28.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_MyStatisticsViewController.h"
#import "TJY_HomePageViewModel.h"
#import "TJY_SignInfoHelper.h"
#import "TJY_DatePickerViewController.h"
@interface TJY_MyStatisticsViewController ()<TJY_SignInfoHelperDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)TJY_SignInfoHelper *  helper;
@end

@implementation TJY_MyStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TJY_HomePageViewModel * model = [TJY_HomePageViewModel  new];
    RACTuple  *  tupe = [RACTuple  tupleWithObjects:self.perId,@"", nil];
    RACSignal * source =   [model.myMonthClockInfoCommand  execute:tupe] ;
    self.helper = [[TJY_SignInfoHelper  alloc] initWithTableView:self.tableView sourceSignal:source selectionCommand:nil customCellClass:nil];
    self.helper.delegate = self;
    self.helper.flag = 3;
    self.titleView.titleLabel.text = self.titleString;
}
-(void)pushViewControllersIndexPath:(NSIndexPath *)indexPath flag:(NSInteger)flag titleString:(NSString *)text{
    if (flag==3) {
        TJY_DatePickerViewController  *  vc = [[UIStoryboard  storyboardWithName:@"HomePage" bundle:nil] instantiateViewControllerWithIdentifier:@"TJY_DatePickerViewController"];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        @weakify(self);
        vc.dateBlock = ^(NSString *dateString) {
            @strongify(self);
            RACSignal  *  single = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [subscriber  sendNext:dateString];
                [subscriber  sendCompleted];
                return  [RACDisposable  disposableWithBlock:^{
                }];
            }];
            self.helper.changeCommand = single;
        };
        [self.tabBarController presentViewController:vc animated:YES completion:nil];
    }
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
