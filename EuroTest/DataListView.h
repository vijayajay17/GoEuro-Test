//
//  DataListView.h
//  EuroTest
//
//  Created by Vijay on 9/28/15.
//  Copyright (c) 2015 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@protocol PrintSelectedValue <NSObject>

-(void)printSelectedValue:(NSString *)selectedName;

@end

@interface DataListView : UIView <UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property(nonatomic, weak) id <PrintSelectedValue> printValue;
@property(nonatomic) UITableView *listTableView;
@property(nonatomic) NSArray *dataListArray;
- (instancetype)initWithListArray:(NSArray *)dataList;
-(void)reloadTableView:(NSArray *)dataArray;
@end
