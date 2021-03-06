//
//  TJY_HomePageHelper.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/17.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_HomePageHelper.h"
#import "TJY_HomeCollectionViewCell.h"
#import  <SDCycleScrollView.h>
@interface  TJY_HomePageHelper()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
{
    RACCommand *_selection;
    UICollectionView  * _collectionView;
    SDCycleScrollView *bannerView;
}
@property(strong, nonatomic) NSMutableDictionary  *  dic;
@end
@implementation TJY_HomePageHelper

-(instancetype)initWithCollectionView:(UICollectionView *)collectionView dataSource:(RACSignal *)source selectionCommand:(RACCommand *)command templateCell:(UINib *)nibCell{
    if (self = [super  init]) {
        _collectionView =  collectionView;
        _selection =  command;
        _collectionView.delegate = self;
        _collectionView.dataSource =  self;
        self.imgArray = [NSMutableArray  array];
        @weakify(self);
        [source  subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            NSArray  * array = [TJY_AdInfomation  mj_objectArrayWithKeyValuesArray:[x  objectForKey:@"result"]];
            [array  enumerateObjectsUsingBlock:^(TJY_AdInfomation  *  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString   * url = [NSString  stringWithFormat:@"%@%@",CNHB_SERVER,obj.imageUrl];
                [self.imgArray   addObject:url];
            }];
            [self->_collectionView  reloadData];
        } error:^(NSError * _Nullable error) {
            GMLog("....%@",error.description);
        }];
        [_collectionView  registerNib:nibCell forCellWithReuseIdentifier:@"myCell"];
        [_collectionView  registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"myHeader"];
    }
    return   self;
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TJY_HomeCollectionViewCell  *  cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    cell.model = [self.dic objectForKey:[NSIndexPath  indexPathWithIndex:indexPath.section]][indexPath.item];
    return   cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  [[self.dic objectForKey:[NSIndexPath  indexPathWithIndex:section]] count];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  self.dic.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView  deselectItemAtIndexPath:indexPath animated:YES];
    RACTuple  *  tuple = [RACTuple  tupleWithObjects:indexPath, nil] ;
    [_selection  execute:tuple];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return   CGSizeMake((SCREEN_W-70)/4.0, 80);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return   UIEdgeInsetsMake(0, 20, 20, 20);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSArray  * title = @[@"智能考勤",@"人事管理",@"财务管理",@"行政管理"];
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"myHeader" forIndexPath:indexPath];
    for (UIView *view in headerView.subviews) { [view removeFromSuperview]; }
    UILabel *label = [[UILabel alloc] init];//WithFrame:CGRectMake(20, 0, SCREEN_W-40, 40)
    label.tag = indexPath.section;
    label.text = title[indexPath.section];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = ssRGBHex(0x222222);
    [headerView addSubview:label];
    if (indexPath.section==0) {
        bannerView = [[SDCycleScrollView  alloc] init];
        [headerView addSubview:bannerView];
        [bannerView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.mas_equalTo(20);
            make.trailing.mas_equalTo(-20);
            make.height.mas_equalTo(SCREEN_W/1200*605);
        }];
        [label  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(headerView);
            make.trailing.mas_equalTo(-20);
        }];
        bannerView.layer.cornerRadius = 15;
        bannerView.layer.masksToBounds = YES;
         [self  configBannerView];
    }else{
        [label  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.height.mas_equalTo(40);
            make.trailing.mas_equalTo(-20);
        }];
        UIView  *lineView = [[UIView  alloc] init];
        [headerView  addSubview:lineView];
        [lineView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(label);
            make.top.mas_equalTo(headerView);
            make.height.mas_equalTo(0.8);
        }];
        lineView.backgroundColor = ssRGBHex(0xdbdbdb);
    }
    return headerView;
}
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        CGSize size = {SCREEN_W, SCREEN_W/1200*605+80};
        return size;
    }
    else
    {
        CGSize size =CGSizeMake(SCREEN_W, 40);
        return size;
    }
}

#pragma mark - SDCycleScrollViewDelegate

-(void)pushAdDetailViewControllerWithDidSelectItemAtIndex:(NSInteger)index{

    dispatch_async(dispatch_get_main_queue(), ^{
      
    });
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}
-(void)configBannerView{
    GMLog("imgArray:::%@",self.imgArray);
    bannerView.imageURLStringsGroup = self.imgArray;
    bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    bannerView.currentPageDotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
    bannerView.pageDotColor = [UIColor darkTextColor];
    bannerView.delegate = self;
    bannerView.autoScroll = false;
    bannerView.autoScrollTimeInterval = 5;
    bannerView.placeholderImage = [UIImage imageNamed:@"banner"];
}


-(void)dealWithModel{
    _dic = [NSMutableDictionary  dictionary];
    NSArray  *  first = @[@"zhinengdaka",@"baifangqiandao",@"qingjiashenpi",@"bukashenpi",@"waichushenpi",@"jiabanshenpi",@"chuchaishenpi"];
    NSArray  *  firstTitle = @[@"智能打卡",@"拜访签到",@"请假审批",@"补卡审批",@"外出审批",@"加班审批",@"出差审批"];
    NSArray  *  second = @[@"gongsikuangjia",@"danganwenjian"];
    NSArray  *  secondTitle = @[@"公司框架",@"档案文件"];
    NSArray  *  third = @[@"feiyongbaoxiao",@"feiyongshenqing",@"cangkujinhuo",@"cangkuxiaohuo"];
    NSArray  *  thirdTitle = @[@"费用报销",@"费用申请",@"仓库进货",@"仓库销货"];
    NSArray  *  fourth = @[@"wupinlingyong",@"yongcheshenqing",@"yonyinshenqing",@"caigoushenqing"];
    NSArray  *  fourthTitle = @[@"物品领用",@"用车申请",@"用印申请",@"采购申请"];
    [self  handleModelWithImg:first title:firstTitle  index:0];
    [self  handleModelWithImg:second title:secondTitle index:1];
    [self  handleModelWithImg:third title:thirdTitle index:2];
    [self  handleModelWithImg:fourth title:fourthTitle index:3];
}
-(void)handleModelWithImg:(NSArray*)img title:(NSArray*)title index:(NSInteger)index{
    NSMutableArray  * array = [NSMutableArray  array];
    [img  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TJY_AdInfomation *  model = [[TJY_AdInfomation  alloc] init];
        model.title = title[idx];
        model.imageUrl = img[idx];
        [array  addObject:model];
    }];
    [_dic  setObject:array forKey:[NSIndexPath  indexPathWithIndex:index]];
}
-(NSMutableDictionary *)dic{
    if (!_dic) {
        [self dealWithModel];
    }
    return   _dic;
}
@end
