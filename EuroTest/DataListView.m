//
//  DataListView.m
//  EuroTest
//
//  Created by Vijay on 9/28/15.
//  Copyright (c) 2015 Vijay. All rights reserved.
//

#import "DataListView.h"

@implementation DataListView

- (instancetype)initWithListArray:(NSArray *)dataList
{
    self = [super init];
    if (self) {
        self.dataListArray = dataList;
        if([self.dataListArray count]>0)
        {
            [self deviceLocation];
        }
    }
    [self iniatialiseView];
    return self;
}

-(void)iniatialiseView
{
    self.listTableView = [[UITableView alloc] init];
    self.listTableView.backgroundColor = [UIColor whiteColor];
    self.listTableView.frame = CGRectMake(0, 0, 200, 100);
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    [self addSubview:self.listTableView];

}

-(void)reloadTableView:(NSArray *)dataArray
{
    self.dataListArray = dataArray;
    if([self.dataListArray count]>0)
    {
        [self deviceLocation];
    }
    else
    {
        [self.listTableView reloadData];
    }
    
}

#pragma mark TableView Datasource and Delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.dataListArray.count<=0)
    {
        return 1;
    }
    else
        return [self.dataListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.dataListArray.count<=0)
    {
    cell.textLabel.text = @"No Results found";
    }
    else
    {
    cell.textLabel.text =[[self.dataListArray objectAtIndex:indexPath.row] objectForKey:@"fullName"];
    }
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.dataListArray count]>0)
    {
        if([self.printValue respondsToSelector:@selector(printSelectedValue:)])
        {
            [self.printValue printSelectedValue:[[self.dataListArray objectAtIndex:indexPath.row] objectForKey:@"fullName"]];
        }
    }
    
}


-(void)deviceLocation
{
   CLLocationManager *locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self sortTableWithCurrentLocation:LocationAtual];
}


- (void)sortTableWithCurrentLocation:(CLLocation *)currentLocation
{
    self.dataListArray = [self.dataListArray sortedArrayUsingComparator: ^(id a, id b)
                       {
                           CLLocation *shopLocationA = [[CLLocation alloc] initWithLatitude:[[[a objectForKey:@"geo_position"] objectForKey:@"latitude"] doubleValue] longitude:[[[a objectForKey:@"geo_position"] objectForKey:@"longitude"] doubleValue]];
                           CLLocation *shopLocationB = [[CLLocation alloc] initWithLatitude:[[b objectForKey:@"latitude"] doubleValue] longitude:[[b objectForKey:@"longitude"] doubleValue]];
                           
                           CLLocationDistance distA = [shopLocationA distanceFromLocation:currentLocation];
                           CLLocationDistance distB = [shopLocationB distanceFromLocation:currentLocation];
                           
                           if (distA < distB) {
                               return (NSComparisonResult)NSOrderedAscending;
                           } else if ( distA > distB) {
                               return (NSComparisonResult)NSOrderedDescending;
                           } else {
                               return (NSComparisonResult)NSOrderedSame;
                           }
                       }];
    
    [self.listTableView reloadData];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
