//
//  CYYRecommendViewController.m
//  百思不得姐01
//
//  Created by ma c on 16/4/7.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYRecommendViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "CYYRecommendCategoryModel.h"
#import "CYYRecomendCategoryTableViewCell.h"
#import "CYYRecommendUserTableViewCell.h"

#import "CYYRecommendUserModel.h"
#import "MJRefresh.h"

#define CYYSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]

static NSString *const CYYCategory = @"category";
static NSString *const CYYUser = @"user";

@interface CYYRecommendViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *categories;

//左边的类别表格
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
//右边的用户表格
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
//请求参数
@property (nonatomic, strong) NSMutableDictionary *params;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation CYYRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加tableView
    [self setupTableView];

    //添加刷新控件
    [self setupRefresh];
   
    //加载左侧数据
    [self loadCategory];
}

- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
/**
 *  加载左侧数据
 */
- (void)loadCategory{
    //显示指示器
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    //发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //隐藏指示器
        [SVProgressHUD dismiss];
        
        self.categories = [CYYRecommendCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //刷新表格
        [self.categoryTableView reloadData];
        
        //默认选中首行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        //让用户表格进入下拉刷新zhuangtai
        [self.userTableView.mj_header beginRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //        //隐藏指示器
        //        [SVProgressHUD dismiss];
        //显示错误信息
        [SVProgressHUD showErrorWithStatus:@"加载信息失败"];
        
    }];
}
- (void)setupTableView{
    self.categoryTableView.showsVerticalScrollIndicator = NO;
    //注册
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CYYRecomendCategoryTableViewCell class]) bundle:nil] forCellReuseIdentifier:CYYCategory];
    
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CYYRecommendUserTableViewCell class]) bundle:nil] forCellReuseIdentifier:CYYUser];
    
    //设置inset
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    self.userTableView.rowHeight = 70;
    //设置标题
    self.title = @"推荐关注";
    //设置背景
    self.view.backgroundColor = RGB(223, 223, 223);
}

/**
 *  添加刷新控件
 */
- (void)setupRefresh{
    
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
   
}

#pragma mark - 加载用户数据 methods
- (void)loadNewUsers{
    CYYRecommendCategoryModel *refresh = CYYSelectedCategory;
    //设置当前页码为1
    refresh.currentpage = 1;
    //发送请求给服务器。请求右侧数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(refresh.id);
    params[@"page"] = @(refresh.currentpage);
    
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //字典数组->模型数组
        NSArray *users = [CYYRecommendUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //清除所有旧数据
        [refresh.users removeAllObjects];
        //添加到当前类别对应的用户数组中
        [refresh.users addObjectsFromArray:users];
        
        //保存总数
        refresh.total = [responseObject[@"total"] integerValue];
        
        //对多次请求的处理
        if (self.params != params) return;
        
        //刷新右边用户表格
        [self.userTableView reloadData];
        
        //结束刷新
        [self.userTableView.mj_header endRefreshing];
        
        //让底部控件结束刷新
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
        if (self.params != params) return;
        
        [SVProgressHUD showErrorWithStatus:@"加载信息失败"];
        //结束刷新
        [self.userTableView.mj_header endRefreshing];
    }];

}

- (void)loadMoreUsers{
    
    CYYRecommendCategoryModel *category = CYYSelectedCategory;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.id);
    params[@"page"] = @(++category.currentpage);
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //字典数组->模型数组
        NSArray *users = [CYYRecommendUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //添加到当前类别对应的用户数组中
        [category.users addObjectsFromArray:users];
        
        //对多次请求的处理
        if (self.params != params) return;
        
        //刷新右边用户表格
        [self.userTableView reloadData];
        //让底部控件结束刷新

        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载信息失败"];
        [self.userTableView.mj_footer endRefreshing];
    }];
}
/**
 *  时刻监测footer的状态
 */
- (void)checkFooterState{
    
    
    CYYRecommendCategoryModel *refresh = CYYSelectedCategory;
    //每次刷新右边数据时，都控制footer显示或者隐藏
    self.userTableView.mj_footer.hidden = (refresh.users.count == 0);
    //让底部控件结束刷新
    if (refresh.users.count == refresh.total) {//全部数据已经加载完毕
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        //结束刷新
        [self.userTableView.mj_footer endRefreshing];
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.categoryTableView) return self.categories.count;
    //右边的用户表格
        //检测footer的状态
    [self checkFooterState];

    return [CYYSelectedCategory users].count;
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.categoryTableView) {//左边的类别表格
        CYYRecomendCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CYYCategory];
        cell.category = self.categories[indexPath.row];
        return cell;
    }else{//右边的用户表格
        CYYRecommendUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CYYUser];

        cell.user = [CYYSelectedCategory users][indexPath.row];
        return cell;
    }
      
}

#pragma mark - UITableViewDelegate methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //结束刷新
    [self.userTableView.mj_header endRefreshing];
    [self.userTableView.mj_footer endRefreshing];
    CYYRecommendCategoryModel *model  = self.categories[indexPath.row];
    
    if (model.users.count) {
        [self.userTableView reloadData];
    }else{
        //解决网络延迟问题，赶紧刷新数据。目的是：马上显示当亲catrogry的用户数据
        [self.userTableView reloadData];
        //开始刷新
        [self.userTableView.mj_header beginRefreshing];
        
            }
}


#pragma mark - 控制器的销毁 methods

- (void)dealloc{
    //销毁控制器
    [self.manager.operationQueue cancelAllOperations];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
