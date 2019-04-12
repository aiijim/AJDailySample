//
//  AJAssetLibraryViewController.m
//  AJDailySample
//
//  Created by aiijim on 2019/4/12.
//  Copyright © 2019 aiijim. All rights reserved.
//

#import "AJAssetLibraryViewController.h"
#import "AJAlbumViewController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"

@interface AJAssetLibraryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ALAssetsLibrary* assetsLibrary;
@property (nonatomic, strong) NSArray* albumsArray;
@property (nonatomic, strong) UITableView* tableView;

@end

@implementation AJAssetLibraryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"AssetLibrary Sample";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied)
    {
        UIAlertController* alert = [[UIAlertController alloc] init];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addAction:action];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
    
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSMutableArray* albums = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        NSLog(@"Group:%@", group);
        __strong typeof(self) strongSelf = weakSelf;
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [albums addObject:group];
        } else {
            if ([albums count] > 0) {
                NSLog(@"有照片");
                strongSelf.albumsArray = [albums copy];
                [strongSelf.tableView reloadData];
            } else {
                NSLog(@"没有任何照片");
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    UIBarButtonItem* saveImageAction = [[UIBarButtonItem alloc] initWithTitle:@"保存到相册" style:UIBarButtonItemStylePlain target:self action:@selector(saveScreenShotToAlbum)];
    self.navigationItem.rightBarButtonItem = saveImageAction;
}

- (void) saveScreenShotToAlbum
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.assetsLibrary writeImageToSavedPhotosAlbum:img.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
        NSLog(@"%@", assetURL);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.albumsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static char* identifier = __PRETTY_FUNCTION__;
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:identifier]];
    if(!cell)
    {
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithUTF8String:identifier]];
    }
    
    if ([indexPath row] < self.albumsArray.count)
    {
        ALAssetsGroup* group = [self.albumsArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
        cell.imageView.image = [UIImage imageWithCGImage:[group posterImage]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([indexPath row] < self.albumsArray.count)
    {
        ALAssetsGroup* group = [self.albumsArray objectAtIndex:[indexPath row]];
        AJAlbumViewController* albumViewController = [[AJAlbumViewController alloc] init];
        albumViewController.group = group;
        [self.navigationController pushViewController:albumViewController animated:YES];
    }
}

@end
#pragma clang diagnostic pop
