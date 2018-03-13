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

@interface giphyCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray<GiphyImage *> *gifList;
@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation giphyCollectionViewController

static const float CELL_HEIGHT = 140;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *vfl = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60) collectionViewLayout:vfl];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView];
    
    self.gifList = [[NSArray alloc] init];
    
    [self.collectionView registerClass:[GifCell class] forCellWithReuseIdentifier:[GifCell cellIdentifier]];
    self.collectionView.refreshControl = [[UIRefreshControl alloc] init];
    [self.collectionView.refreshControl addTarget:self action:@selector(refreshControlTriggered) forControlEvents:UIControlEventValueChanged];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 40)];
    [self.view addSubview:self.searchBar];
    self.searchBar.delegate = self;
    
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
    CGFloat cellWidth, cellHeight;
    
    if (indexPath.row % 5 < 2) {
        cellWidth = self.view.frame.size.width/2 - 5;
    } else {
        cellWidth = self.view.frame.size.width/3 - 7;
    }
    cellHeight = CELL_HEIGHT;
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

#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"text editing");
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"click");
     [self searchForGifs:searchBar.text];
    if ([searchBar isFirstResponder]) {
        [searchBar resignFirstResponder];
    }
}
     
-(void)searchForGifs:(NSString *)searchText {
    [[giphyService sharedService] getGifsFromSearchText:searchText withBlock:^(NSArray<GiphyImage *> * _Nullable results, NSError * _Nullable error) {
        [self.collectionView.refreshControl endRefreshing];
        if (error) {
            NSLog(@"Failed getting search results. %@", error);
            return;
        }
        self.gifList = results;
        [self.collectionView reloadData];
    }];
}

@end
