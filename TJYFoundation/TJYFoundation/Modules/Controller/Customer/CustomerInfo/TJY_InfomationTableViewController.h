//
//  TJY_InfomationTableViewController.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/7.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TJY_CustomerViewModel;
@interface TJY_InfomationTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *nationLbl;
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
@property (weak, nonatomic) IBOutlet UITextField *clubCardTF;
@property (weak, nonatomic) IBOutlet UITextField *introduceTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sourceTF;
@property (weak, nonatomic) IBOutlet UITextField *contactTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *economicsSegment;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLbl;
@property (weak, nonatomic) IBOutlet UITextField *buyStatusTF;
@property(nonatomic,copy)NSString  * nationId;
@property(nonatomic,strong)  RACSubject  *  subject;
@property(nonatomic,strong)  TJY_CustomerViewModel *  viewModel;
@end
