//
//  giphyCollectionViewController.m
//  
//
//  Created by Yuri V on 11/05/2017.
//
//

#import "giphyCollectionViewController.h"
#import "GifCell.h"
#import "giphyService.h"
#import "GiphyImage.h"

@interface giphyCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray<GiphyImage *> *gifList;

@end

@implementation giphyCollectionViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *vfl = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) collectionViewLayout:vfl];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView];
    
    self.gifList = [[NSArray alloc] init];
    
    [self.collectionView registerClass:[GifCell class] forCellWithReuseIdentifier:[GifCell cellIdentifier]];
    
    self.collectionView.refreshControl = [[UIRefreshControl alloc] init];
    [self.collectionView.refreshControl addTarget:self action:@selector(refreshControlTriggered) forControlEvents:UIControlEventValueChanged];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self loadPage];
}


-(void)loadPage {
    [self.collectionView.refreshControl beginRefreshing];
    
    [[giphyService sharedService] getHomeGifs:^(NSArray <GiphyImage *> *list, NSError *error) {
        [self.collectionView.refreshControl endRefreshing];
        
        if (error) {
            NSLog(@"Failed getting feed. %@", error);
            return;
        }
        
        self.gifList = list;
        
        [self.collectionView reloadData];
    }];
}

- (void)refreshControlTriggered {
    [self loadPage];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GiphyImage *gif = self.gifList[indexPath.row];
    
    CGFloat cellWidth = self.view.frame.size.width/2 - 5;
    CGFloat cellHeight = [GifCell heightOfCell:cellWidth forGif:gif];
    
    return CGSizeMake(cellWidth, cellHeight);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gifList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GiphyImage *gif = self.gifList[indexPath.row];
    
    GifCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[GifCell cellIdentifier] forIndexPath:indexPath];
    
    [cell updateData:gif];
    
    return cell;
}

@end
