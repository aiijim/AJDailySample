//
//  AJViewController.m
//  AJDailySample
//
//  Created by aiijim on 2018/12/19.
//  Copyright © 2018年 aiijim. All rights reserved.
//

#import "AJViewController.h"

@interface AJViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* dataSource;
@property (nonatomic, strong) NSArray* targetControllerArr;
@end

@implementation AJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"iOS Daily Sample";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.translucent = NO;
    
    self.dataSource = @[@"CoreGraphics", @"ImageIO", @"CoreImage", @"JavaScriptCore", @"WebKit", @"AssetLibrary", @"PhotoKit", @"GCD", @"RunLoop", @"OCRunTime"];
    self.targetControllerArr = @[@"AJCoreGraphicsViewController",@"AJImageIOViewController", @"AJCoreImageViewController", @"AJJSCoreViewController", @"AJWKWebViewController", @"AJAssetLibraryViewController"];
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FirstCellIdentifier"];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.targetControllerArr.count)
    {
        UIViewController* controller = [NSClassFromString(self.targetControllerArr[indexPath.row]) new];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FirstCellIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = [self.dataSource objectAtIndex:[indexPath row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end
