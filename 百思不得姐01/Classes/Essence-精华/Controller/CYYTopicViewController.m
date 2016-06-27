//
//  CYYTopicViewController.m
//  百思不得姐01
//
//  Created by ma c on 16/4/29.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYTopicViewController.h"
#import "AFNetworking.h"
#import "CYYTopic.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "CYYTopicCell.h"
#import "NewViewController.h"



#import "CYYCommentViewController.h"

static NSString *const CYYTopicCellID = @"topic";
@interface CYYTopicViewController ()

/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 当加载下一页数据时需要这个参数 */
@property (nonatomic, copy) NSString *maxtime;
/** 上一次的请求参数 */
@property (nonatomic, strong) NSDictionary *params;

/** 上一次的选中的索引 */
@property (nonatomic, assign) NSInteger lastSelectedIndex;


@end

@implementation CYYTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化表格
    [self setupTableView];
    //添加刷新控件
    [self setupRefresh];
    
}

- (NSString *)type{
    return nil;
}
- (NSMutableArray *)topics{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (void)setupTableView{
    //设置内边距
    CGFloat top = CYYTitlesViewY + CYYTitlesViewH;
    CGFloat bottom = self.tabBarController.tabBar.height;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    //设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CYYTopicCell class]) bundle:nil] forCellReuseIdentifier:CYYTopicCellID];
    
    //监听收到的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSelect) name:CYYTabBarDidSelectNotification object:nil];
}
- (void)tabBarSelect{
    
    //如果连续两次点击  直接刷新
//    if (self.lastSelectedIndex == self.tabBarController.selectedIndex  && self.tabBarController.selectedViewController == self.navigationController){
//        [self.tableView.mj_header beginRefreshing];
//    };
    if (self.lastSelectedIndex == self.tabBarController.selectedIndex  && self.view.isShowingOnKeyWindow){
        [self.tableView.mj_header beginRefreshing];
    };
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
    
}
//添加刷新控件
- (void)setupRefresh{
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    // 自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha= YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}


#pragma mark - 参数

- (NSString *)a{
    return [self.parentViewController isKindOfClass:[NewViewController class]] ? @"newlist" : @"list";
}

#pragma mark- 数据处理
/**
 *  加载新的帖子数据
 */
- (void)loadNewTopics{
    //结束上拉
    [self.tableView.mj_footer endRefreshing];
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = self.type;
    self.params = params;
    //发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
        //对于多次请求的处理
        if (self.params != params) return;
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典 -> 模型
        self.topics = [CYYTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // 清空页码
        self.page = 0;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
    }];
}
/**
 *  加载更多数据
 */
- (void)loadMoreTopics{
    // 结束下拉
    [self.tableView.mj_header endRefreshing];
    
    self.page++;
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = self.type;
    params[@"page"] = @(self.page);
    params[@"maxtime"] = self.maxtime;
    self.params = params;
    
    // 发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.params != params) return;
       
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
       
        // 字典 -> 模型
        NSArray *newTopics = [CYYTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:newTopics];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.params != params) return;
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        // 恢复页码
        self.page--;
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CYYTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CYYTopicCellID];
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

#pragma mark- 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取出帖子模型
    CYYTopic *topic = self.topics[indexPath.row];
    
    return topic.cellHeight;
}
//选择cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CYYCommentViewController *commentVC = [[CYYCommentViewController alloc] init];
    commentVC.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVC animated:YES];
}





@end
