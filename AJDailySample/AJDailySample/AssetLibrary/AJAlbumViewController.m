//
//  AJAlbumViewController.m
//  AJDailySample
//
//  Created by aiijim on 2019/4/12.
//  Copyright © 2019 aiijim. All rights reserved.
//

#import "AJAlbumViewController.h"

@interface AJAlbumViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray<ALAsset*>* assetsArray;

@end

@implementation AJAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.group valueForProperty:ALAssetsGroupPropertyName];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 20.0f;
    flowLayout.minimumInteritemSpacing = 8.0f;
    flowLayout.itemSize = CGSizeMake(100.0f, 100.0f);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectInset(self.view.bounds, 20, 20)  collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([self class])];
    [self.view addSubview:self.collectionView];
    
    NSMutableArray<ALAsset*>* assets = [NSMutableArray<ALAsset*> array];
    __weak typeof(self) weakSelf = self;
    [self.group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf && result)
        {
            [assets addObject:result];
            strongSelf.assetsArray = [assets copy];
            [strongSelf.collectionView reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    if ([indexPath row] < [self.assetsArray count])
    {
        ALAsset* asset = [self.assetsArray objectAtIndex:[indexPath row]];
        UIImage* image = [UIImage imageWithCGImage:asset.thumbnail];//[UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage]];
        cell.contentView.layer.contents = (__bridge id)image.CGImage;
        cell.contentView.layer.borderColor = [UIColor orangeColor].CGColor;
        cell.contentView.layer.borderWidth = 1.0f;
    }
    return cell;
}

@end
