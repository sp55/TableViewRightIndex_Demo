//
//  ViewController.m
//  TableViewRightIndex_Demo
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "ViewController.h"
#import "PlaceModel.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArr; //数据源数组
@property (nonatomic, strong) NSMutableArray *sectionsArr;//存放section对应的userObjs数组数据

//UITableView索引搜索工具
@property (nonatomic, strong) UILocalizedIndexedCollation *collation;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initDataArr];
}
#pragma mark -界面
-(void)initUI
{
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)  style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];

}
#pragma mark -配置分组信息
-(void)initDataArr
{
    //初始化测试数据
    NSMutableArray *cityArr = [[NSMutableArray alloc] init];
    _dataArr = [NSMutableArray arrayWithObjects:@"北京",@"安徽",@"合肥",@"邯郸",@"蚌埠",@"上海",@"广州",@"西安",@"淮南",@"江西",@"武汉",@"广西",@"河北",@"俄罗斯",@"盐城",@"江苏",@"新疆",@"乌鲁木齐", nil];
    for (int i = 0; i < _dataArr.count; i++) {
        [cityArr addObject:[[PlaceModel alloc] initWithNameStr:_dataArr[i]]];
    }
    
    
    
    //获得当前UILocalizedIndexedCollation对象并且引用赋给collation,A-Z的数据
    self.collation = [UILocalizedIndexedCollation currentCollation];
    
    //获得索引数和section标题数
    NSInteger index, sectionTitlesCount = [[_collation sectionTitles] count];
    
    //临时数据，存放section对应的Objs数组数据
    NSMutableArray *tmpSectionArr = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    //设置sections数组初始化：元素包含userObjs数据的空数据
    for (index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [tmpSectionArr addObject:array];
    }
    
    //将用户数据进行分类，存储到对应的sesion数组中
    for (PlaceModel *placeModel in cityArr) {
        
        //根据timezone的localename，获得对应的的section number
        NSInteger sectionNumber = [_collation sectionForObject:placeModel collationStringSelector:@selector(name)];
        
        //获得section的数组
        NSMutableArray *sectionPlaceArr = [tmpSectionArr objectAtIndex:sectionNumber];
        
        //添加内容到section中
        [sectionPlaceArr addObject:placeModel];
    }
    
    //排序，对每个已经分类的数组中的数据进行排序，如果仅仅只是分类的话可以不用这步
    for (index = 0; index < sectionTitlesCount; index++) {
        
        NSMutableArray *placeArrForSection = [tmpSectionArr objectAtIndex:index];
        
        //获得排序结果
        NSArray *sortedUserObjsArrayForSection = [_collation sortedArrayFromArray:placeArrForSection collationStringSelector:@selector(name)];
        
        //替换原来数组
        [tmpSectionArr replaceObjectAtIndex:index withObject:sortedUserObjsArrayForSection];
    }
    self.sectionsArr = tmpSectionArr;

}

#pragma mark -- delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // The number of sections is the same as the number of titles in the collation.
    return [[_collation sectionTitles] count];
    
}

//设置每个Section下面的cell数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // The number of time zones in the section is the count of the array associated with the section in the sections array.
    NSArray *ObjsInSection = [_sectionsArr objectAtIndex:section];
    return [ObjsInSection count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Get the time zone from the array associated with the section index in the sections array.
    NSArray *userNameInSection = [_sectionsArr objectAtIndex:indexPath.section];
    // Configure the cell with the time zone's name.
    PlaceModel *userObj = [userNameInSection objectAtIndex:indexPath.row];
    cell.textLabel.text = userObj.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 * 跟section有关的设定
 */
//设置section的Header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *ObjsInSection = [_sectionsArr objectAtIndex:section];
    if(ObjsInSection == nil || [ObjsInSection count] <= 0) {
        return nil;
    }
    return [[_collation sectionTitles] objectAtIndex:section];
}
//设置索引标题
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [_collation sectionIndexTitles];
}
//关联搜索
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_collation sectionForSectionIndexTitleAtIndex:index];
}



@end
