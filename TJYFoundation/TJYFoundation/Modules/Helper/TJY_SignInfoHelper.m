//
//  TJY_SignInfoHelper.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/27.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_SignInfoHelper.h"
#import "TJY_SignClockInfo.h"
#import "TJY_MySignInfo.h"
#import "TJY_HomePageViewModel.h"
@interface TJY_SignInfoHelper ()<UITableViewDelegate,UITableViewDataSource>
{
    RACCommand *_selection;
    UITableView *_tableView;
    NSArray  *  _sectionTitleArray;
}
@property(nonatomic,copy)NSString  * numString;
@property(nonatomic,strong)NSMutableDictionary  * dic;

@end

@implementation TJY_SignInfoHelper
- (instancetype)initWithTableView:(UITableView *)tableView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)selection customCellClass:(Class)clazz{
    if (self = [super  init]) {
        _tableView = tableView;
        _selection = selection;
        if (!source) {
            self.dataArray = @[];
            [_tableView  reloadData];
        }else{
            @weakify(self);
            [source  subscribeNext:^(RACTuple  *tupe) {
                @strongify(self);
               self.dataArray = tupe.first;
                self->_numString = tupe.second?tupe.second:@"";
                self->_sectionTitleArray = tupe.third?tupe.third:@[];
                [self->_tableView  reloadData];
            }];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView  alloc] initWithFrame:CGRectZero];
    }
    return   self;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell  *  cell;
      static  NSString  * myCell = @"myCell";
      static  NSString  * myCellId = @"myCellId";
    if (self.flag ==2) {
        cell = [tableView  dequeueReusableCellWithIdentifier:myCell];
    }else if (self.flag==3){
        cell = [tableView  dequeueReusableCellWithIdentifier:myCellId];
    }
    if (!cell) {
        if (self.flag==2) {
                cell = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
                cell = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myCellId];
        }
        cell.textLabel.font = [UIFont  systemFontOfSize:14];
        cell.textLabel.textColor = ssRGBHex(0x222222);
        cell.detailTextLabel.font = [UIFont  systemFontOfSize:14];
        cell.detailTextLabel.textColor = ssRGBHex(0x999999);
        cell.detailTextLabel.numberOfLines = 0;
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    }
    if (self.flag ==2) {
        BaseModel * model = self.dataArray[indexPath.row];
        cell.textLabel.text = model.title;
        cell.detailTextLabel.text = model.detail;
    }else if (self.flag==3){
        CdClock  *  clock = self.dataArray[indexPath.section-1];
        ResList  *  model = clock.resList[indexPath.row];
        cell.textLabel.text = [NSString  stringWithFormat:@"%@  (%@)",model.clockDate,model.week];
        if (indexPath.section==1||indexPath.section==2||indexPath.section==6) {
             cell.detailTextLabel.text = @"";
        }else{
            if (indexPath.section==3 ||indexPath.section==4) {
                cell.textLabel.text = [NSString  stringWithFormat:@"%@  (%@)  %@",model.clockDate,model.week,[self  dateWithTimeIntervalString:model.clockTime]];
                if (indexPath.section==3) {
                    cell.detailTextLabel.text = [NSString  stringWithFormat:@"上班迟到%@分钟",model.lateTime];
                }else{
                    cell.detailTextLabel.text = [NSString  stringWithFormat:@"下班早退%@分钟",model.lateTime];
                }
            }else{
                cell.detailTextLabel.text = model.address?model.address:(model.clockTime?[self  dateWithTimeIntervalString:model.clockTime]:@"");
            }
        }
    }
    return   cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.flag==3) {
        if (section==0) {
            return  0;
        }
        BOOL  isOpen = [[self.dic objectForKey:[NSString  stringWithFormat:@"key%ld",section]] boolValue];
        if (isOpen) {
            CdClock  *  model = self.dataArray[section-1];
            return  model.resList.count;
        }else{
            return  0;
        }
      
    }
    return  self.dataArray.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.flag ==2) {
        UIView  * v = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
        UIView  *sub = [[UIView  alloc] init];
        [v addSubview: sub];
        [sub  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.leading.trailing.mas_equalTo(v);
            make.height.mas_equalTo(44);
        }];
        sub.backgroundColor = [UIColor  whiteColor];
        v.backgroundColor = ssRGBHex(0xeaeaea);
        UIImageView * imgL = [[UIImageView alloc] init];
        imgL.image = [UIImage  imageNamed:@"leftsmall"];
        [sub addSubview:imgL];
        [imgL  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.centerY.mas_equalTo(sub.centerY);
        }];
        UILabel  *lbl = [[UILabel  alloc] init];
        NSDateFormatter  * formatter = [[NSDateFormatter  alloc] init];
        [formatter  setDateFormat:@"yyyy.MM"];
        lbl.text = [formatter  stringFromDate:[NSDate  date]];
        lbl.textColor = ssRGBHex(0x222222);
        lbl.font = [UIFont  systemFontOfSize:12 ];
        [sub addSubview:lbl];
        [lbl  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(imgL.mas_trailing).mas_offset(20);
            make.centerY.mas_equalTo(sub.mas_centerY);
        }];
        UIImageView * imgR = [[UIImageView alloc] init];
        imgR.image = [UIImage  imageNamed:@"rightsmall"];
        [sub addSubview:imgR];
        [imgR  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(lbl.mas_trailing).mas_offset(20);
            make.centerY.mas_equalTo(sub.centerY);
        }];
        UILabel * detail = [UILabel  new];
        detail.text = _numString.length>0?[NSString  stringWithFormat:@"总考勤人数:%@",_numString]:@"";
        detail.textColor = ssRGBHex(0x222222);
        detail.font = [UIFont  systemFontOfSize:12 ];
        [sub  addSubview:detail];
        [detail  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(sub).mas_offset(-15);
            make.centerY.mas_equalTo(sub.mas_centerY);
        }];
        return  v;
    }else if (self.flag==3){
        UIView  * v = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 44)];
        UILabel  * lbl = [[UILabel  alloc] init];
        lbl.textColor = ssRGBHex(0x222222);
        lbl.font = [UIFont  systemFontOfSize:14 ];
        [v  addSubview:lbl];
        [lbl  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(v).mas_offset(15);
            make.centerY.mas_equalTo(v.mas_centerY);
        }];
        if (section==0) {
            NSDateFormatter  *  formatter = [[NSDateFormatter  alloc] init];
            [formatter  setDateFormat:@"yyyy.MM.dd"];
            lbl.text =self.numString.length>0?self.numString: [formatter  stringFromDate:[NSDate  date]];
            UIImageView  *  img = [[UIImageView  alloc] init];
            img.image = [UIImage  imageNamed:@"undown"];
            [v  addSubview:img];
            [img  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(lbl.mas_trailing).mas_offset(10);
                make.centerY.mas_equalTo(v.mas_centerY);
            }];
        }else{
            BOOL  isOpen = [[self.dic  objectForKey: [NSString  stringWithFormat:@"key%ld",section]] boolValue];
             lbl.text = _sectionTitleArray[section-1];
            UIImageView  *  img = [[UIImageView  alloc] init];
            img.image = [UIImage  imageNamed:isOpen?@"down":@"up"];
            [v  addSubview:img];
            [img  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(v.mas_trailing).mas_offset(-15);
                make.centerY.mas_equalTo(v.mas_centerY);
            }];
            CdClock  *  clocks = self.dataArray[section-1];
            NSArray *detailArray=@[[NSString  stringWithFormat:@"%@天",clocks.resCount],[NSString  stringWithFormat:@"%@天",clocks.resCount],[NSString  stringWithFormat:@"%@次,共%@分钟",clocks.resCount,clocks.lateTimeSum],[NSString  stringWithFormat:@"%@次,共%@分钟",clocks.resCount,clocks.lateTimeSum],[NSString  stringWithFormat:@"%@次",clocks.resCount],[NSString  stringWithFormat:@"%@次",clocks.resCount],[NSString  stringWithFormat:@"%@次",clocks.resCount]];
            UILabel  *  label = [[UILabel  alloc] init];
            label.textColor = ssRGBHex(0x999999);
            label.font = [UIFont  systemFontOfSize:14 ];
            label.text = detailArray[section-1];
            [v  addSubview:label];
            [label  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(img.mas_leading).mas_offset(-10);
                make.centerY.mas_equalTo(v.mas_centerY);
            }];
        }
        UITapGestureRecognizer  *  tap = [[UITapGestureRecognizer  alloc] init];
        @weakify(self);
        [[tap  rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self);
            if (section==0) {
                if (self.delegate && [self->_delegate  respondsToSelector:@selector(pushViewControllersIndexPath:flag:titleString:)]) {
                    [self->_delegate  pushViewControllersIndexPath:nil flag:self.flag titleString:@""];
                }
                return ;
            }
            BOOL  isClosed = [[self.dic  objectForKey: [NSString  stringWithFormat:@"key%ld",section]] boolValue];
            [self.dic  setValue:[NSNumber  numberWithBool:!isClosed] forKey:[NSString  stringWithFormat:@"key%ld",section]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_tableView  reloadSection:section withRowAnimation:UITableViewRowAnimationFade];
                if (!isClosed) {
                    CdClock  *  model = self.dataArray[section-1];
                    if (model.resList.count) {
                          [self->_tableView  scrollToRow:0 inSection:section atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    }
                }
            });
        }];
        [v addGestureRecognizer:tap];
        return   v;
    }
    return   nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.flag==2) {
            return  64;
    }else if (self.flag==3){
           return  44;
    }
    return  0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.flag ==3 && section==0) {
        UIView  * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 10)];
        v.backgroundColor = [UIColor  whiteColor];
        return  v;
    }
    return  nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.flag ==3 && section==0) {
        return  10;
    }
    return  0.001;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.flag==3) {
        return  self.dataArray.count+1;
    }else if (self.flag==2){
        return  1;
    }
    return  0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    if (self.flag==2) {
        if (self.delegate && [self->_delegate  respondsToSelector:@selector(pushViewControllersIndexPath:flag:titleString:)]) {
              BaseModel * model = self.dataArray[indexPath.row];
            [self->_delegate  pushViewControllersIndexPath:indexPath flag:self.flag titleString:model.title];
        }
    }
}


-(void)viewDidLayoutSubviews {
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
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

-(NSString *)dateWithTimeIntervalString:(NSString *)string{
    
    NSString * timeStampString = string;
    NSTimeInterval _interval=[timeStampString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"HH:mm:ss"];
    return [objDateformat stringFromDate: date];
}

-(NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = [NSMutableDictionary  dictionary];
        for (int i=0; i<self.dataArray.count; i++) {
            [_dic  setValue:[NSNumber  numberWithBool:false] forKey:[NSString stringWithFormat:@"key%d",i+1]];
        }
    }
    return _dic;
}
-(void)setChangeCommand:(RACSignal *)changeCommand{
    _changeCommand = changeCommand;
    @weakify(self);
    [changeCommand  subscribeNext:^(NSString * x) {
        TJY_HomePageViewModel * model = [TJY_HomePageViewModel  new];
        RACTuple  *  tupe = [RACTuple  tupleWithObjects:@"",[x  substringToIndex:7], nil];
        [[model.myMonthClockInfoCommand  execute:tupe] subscribeNext:^(RACTuple  *tupe) {
            @strongify(self);
            self.dataArray = tupe.first;
            self.numString = x;
            self->_sectionTitleArray = tupe.third?tupe.third:@[];
            [self->_tableView  reloadData];
        }error:^(NSError * _Nullable error) {
            GMLog(".....%@",error);
        }] ;
    }error:^(NSError * _Nullable error) {
        GMLog(".......%@",error);
    }];
}
@end
