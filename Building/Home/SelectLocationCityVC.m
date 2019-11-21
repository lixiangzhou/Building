//
//  SelectLocationCityVC.m
//  Building
//
//  Created by Macbook Pro on 2019/3/16.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "SelectLocationCityVC.h"

#define SelectLocationCityCellHeight       45
#define SelectLocationCityCellXibName       @"UITableViewCell"

@interface SelectLocationCityVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasourceArr;
@end

@implementation SelectLocationCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"城市选择";
    
//    self.datasourceArr = [[NSMutableArray alloc] init];
    NSMutableArray *keyArr = self.cityDic.allKeys.mutableCopy;
    [keyArr sortUsingComparator:^NSComparisonResult(NSString *string1, NSString *string2) {
        return [string1 compare:string2];
    }];
    self.datasourceArr = keyArr;
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasourceArr.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.datasourceArr[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *cityArr = [self.cityDic objectForKey:self.datasourceArr[section]];
    return cityArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SelectLocationCityCellXibName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SelectLocationCityCellXibName];
    }
    
    NSArray *cityArr = [self.cityDic objectForKey:self.datasourceArr[indexPath.section]];
    FYCityModel *cityItem = cityArr[indexPath.row];
    cell.textLabel.text = cityItem.cityName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SelectLocationCityCellHeight;
}

//返回一个String数组,TableView就会依次显示在索引上
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.datasourceArr;
}

//响应点击索引时的委托方法

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *cityArr = [self.cityDic objectForKey:self.datasourceArr[indexPath.section]];
    FYCityModel *cityItem = cityArr[indexPath.row];
    
    GlobalConfigClass *configer = [GlobalConfigClass shareMySingle];
    configer.cityModel = cityItem;
    
    if (self.selectCityBlock) {
        self.selectCityBlock(cityItem);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - getters and setters
- (void)setCityDic:(NSMutableDictionary *)cityDic{
    _cityDic = cityDic;
}
@end
