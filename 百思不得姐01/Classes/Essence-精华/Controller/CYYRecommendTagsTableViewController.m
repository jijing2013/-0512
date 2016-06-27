//
//  CYYRecommendTagsTableViewController.m
//  百思不得姐01
//
//  Created by ma c on 16/4/9.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYRecommendTagsTableViewController.h"
#import "CYYRecommendTagsModel.h"

#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "MJExtension.h"
#import "CYYRecommendTagsCell.h"


static NSString * const CYYTagsID = @"tag";

@interface CYYRecommendTagsTableViewController ()
//标签数据
@property (nonatomic, strong) NSArray *tags;

@end

@implementation CYYRecommendTagsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];

    [self loadTags];
    
}
#pragma mark - 加载数据  methods
- (void)loadTags{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CYYRecommendTagsCell class]) bundle:nil] forCellReuseIdentifier:CYYTagsID];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    //发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        self.tags = [CYYRecommendTagsModel mj_objectArrayWithKeyValuesArray:responseObject];

        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载标签失败"];
    }];

}
#pragma mark - 设置tableView methods
- (void)setupTableView{
    self.title = @"推荐标签";
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGB(223, 223, 223);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tags.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CYYRecommendTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:CYYTagsID];
    
    cell.recommendTag = self.tags[indexPath.row];
    
    return cell;
}


@end
