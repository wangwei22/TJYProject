//
//  TJY_SearchViewController.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/8.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_BaseViewController.h"

@interface TJY_SearchViewController : TJY_BaseViewController<UISearchResultsUpdating>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *dataListArry;
@end
