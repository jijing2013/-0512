//
//  CYYCommentViewController.m
//  百思不得姐01
//
//  Created by ma c on 16/5/6.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYCommentViewController.h"
#import "CYYTopicCell.h"
#import "CYYTopic.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "CYYComment.h"
#import "MJExtension.h"
#import "CYYCommentHeaderView.h"
#import "CYYCommentCell.h"


static NSString *const CYYCommentID = @"comment";

@interface CYYCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**最热评论*/
@property (nonatomic, strong) NSArray *hotComments;
/**最新评论*/
@property (nonatomic, strong) NSMutableArray *latestComments;

/*保存帖子的top_cmt*/
@property (nonatomic, strong) CYYComment *saved_top_cmt;
/*当前的页码*/
@property (nonatomic, assign) NSInteger page;

/** 管理者*/
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation CYYCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(223, 223, 223);

    [self setupBasic];
    
    [self setupHeader];
    
    [self setupRefresh];
    
}
//创建管理者
- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)setupRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComment)];
    [self.tableView.mj_header beginRefreshing];
    
    //下拉加载
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    self.tableView.mj_footer.hidden = YES;
}
- (void)loadNewComment{
    //结束之前所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //没有数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            //结束刷新
            [self.tableView.mj_header endRefreshing];
            return;
        }
        
        
        //最热评论
        self.hotComments = [CYYComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        //最新评论
        self.latestComments = [CYYComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
    
        //yema
        self.page = 1;
        
        [self.tableView reloadData];
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
        //控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) {//全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)loadMoreComments{
    
    //结束之前所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //页码
    NSInteger page = self.page + 1;
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"page"] = @(page);
    //最后一个数据的id
    CYYComment *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //没有数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            self.tableView.mj_footer.hidden = YES;
            return;
        }
        //最新评论
        NSArray *newComments = [CYYComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        //页码
        self.page = page;
        [self.tableView reloadData];
        
   
        
        //控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) {//全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        }else{
            //结束刷新
             [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)setupHeader{
    //创建header
    UIView *header = [[UIView alloc] init];
    
    //清空top_cmt
    if (self.topic.top_cmt) {
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }

    
    
    CYYTopicCell *cell = [CYYTopicCell cell];
    cell.topic = self.topic;
    cell.size = CGSizeMake(SCREEN_WIDTH, self.topic.cellHeight);
    [header addSubview:cell];
    header.height = self.topic.cellHeight + 10;
    
    //设置header
    self.tableView.tableHeaderView = header;
}
- (void)setupBasic{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" hightImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //cell设置高度  预估高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //注册commentCell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CYYCommentCell class]) bundle:nil] forCellReuseIdentifier:CYYCommentID];
    
    
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //内边距
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
}
- (void)keyboardWillChangeFrame:(NSNotification *)note{
    //键盘显示/隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //修改底部约束
    self.bottomSpace.constant = SCREEN_HEIGHT - frame.origin.y;
    //动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
//清除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 恢复帖子的top_cmt
    if (self.saved_top_cmt) {
        self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    
    //取消所有任务  
    [self.manager invalidateSessionCancelingTasks:YES];
}

//返回数据 获取评论过程
- (NSArray *)commentsInSection:(NSInteger)section{
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}
//根据indexPath获得数据
- (CYYComment *)commentInIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInSection:indexPath.section][indexPath.row];
}

#pragma mark -UITableViewDataSource methods
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    if (hotCount) return 2;//有“最热评论” “最新评论”
    if (latestCount) return 1; //只有最新评论
    return 0;
    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    //隐藏尾部控件
    tableView.mj_footer.hidden = (latestCount == 0);
    
    if (section == 0) {
        return hotCount ? hotCount : latestCount;
    }
    //非0组
    return latestCount;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //先从缓存池中找header  (使header可以循环引用)
  
    CYYCommentHeaderView *header = [CYYCommentHeaderView headerViewWithTableView:tableView];
    //设置文字
    NSInteger hotCount = self.hotComments.count;
    
    if (section == 0) {
        header.title = hotCount ? @"最热评论" : @"最新评论";
    }else{
        header.title = @"最新评论";
    }
    return header;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    //先从缓存池中找header  (使header可以循环引用)
//    static NSString *ID = @"header";
//    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
//    
//    UILabel *label = nil;
//    
//    if (header == nil) {//缓存池中没有header，自己创建
//        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:ID];
//        header.contentView.backgroundColor = RGB(223, 223, 223);;
//        //创建label
//        label = [[UILabel alloc] init];
//        label.textColor = RGB(67, 67, 67);
//        label.width = 200;
//        label.x = 10;
//        label.tag = CYYHeaderLabelTag;
//        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        [header.contentView addSubview:label];
//    }else{//缓存池中有，从缓存池中取
//        label = (UILabel *)[header viewWithTag:CYYHeaderLabelTag];
//    }
//    //设置文字
//    NSInteger hotCount = self.hotComments.count;
//
//    if (section == 0) {
//        label.text = hotCount ? @"最热评论" : @"最新评论";
//    }else{
//        label.text = @"最新评论";
//    }
//    return header;
//}

//设置viewForHeader
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    //创建头部
//    UIView *header = [[UIView alloc] init];
//    header.backgroundColor = RGB(223, 223, 223);
//    //创建label
//    UILabel *label = [[UILabel alloc] init];
//    label.textColor = RGB(67, 67, 67);
//    label.width = 200;
//    label.x = 10;
//    label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [header addSubview:label];
//    
//    //设置文字
//    NSInteger hotCount = self.hotComments.count;
//    
//    if (section == 0) {
//        label.text = hotCount ? @"最热评论" : @"最新评论";
//    }else{
//        label.text = @"最新评论";
//    }
//    return header;
//    
//}
//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSInteger hotCount = self.hotComments.count;
//    
//    if (section == 0) {
//        return hotCount ? @"最热评论" : @"最新评论";
//    }
//    return @"最新评论";
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CYYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CYYCommentID];

    cell.comment = [self commentInIndexPath:indexPath];
    return cell;
}
#pragma mark - UITableViewDelegate methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
    //控制menu滚动时消失
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    //被点击的cell
    CYYCommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //出现第一响应者
    [cell becomeFirstResponder];
    //显示menuController
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    //添加MenuItem
    UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
    UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
    UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
    menu.menuItems = @[ding, replay, report];
    
    CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, cell.height * 0.5);
    
    [menu setTargetRect:rect inView:cell];
    [menu setMenuVisible:YES animated:YES];
    
}

#pragma mark - UIMenuItem 处理 methods

//点击评论cell的方法
- (void)ding:(UIMenuController *)menu{
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CYYLog(@"%s %@",__func__, [self commentInIndexPath:indexPath].content);
}
- (void)replay:(UIMenuController *)menu{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CYYLog(@"%s %@",__func__, [self commentInIndexPath:indexPath].content);
}
- (void)report:(UIMenuController *)menu{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CYYLog(@"%s %@",__func__, [self commentInIndexPath:indexPath].content);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
