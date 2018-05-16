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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 40)];
    [self.view addSubview:self.searchBar];
    self.searchBar.delegate = self;
    
    [self loadPage];
}

-(void)loadPage {
    [self.collectionView.refreshControl beginRefreshing];
    
    [[giphyService sharedService] getFirstPageWithSearchQueryIfNeeded:nil withBlock:^(NSArray <GiphyImage *> *list, NSError *error) {
        [self.collectionView.refreshControl endRefreshing];
        if (error) {
            NSLog(@"Failed getting feed. %@", error);
            return;
        }
        NSMutableArray *gifs = [self.gifList mutableCopy];
        for (GiphyImage *gif in list) {
            [gifs addObject:gif];
        }
        self.gifList = list;
        [self.collectionView reloadData];
    }];
}

-(void)loadNextPage:(NSString *)offset withSearchTextIfNeeded:(NSString *)searchText {
    [self.collectionView.refreshControl beginRefreshing];
    
    searchText = [searchText isEqualToString:@""] ? nil : searchText;
    
    [[giphyService sharedService] getNextPageWithSearchQueryIfNeeded:searchText withOffset:offset withBlock:^(NSArray<GiphyImage *> * _Nullable results, NSError * _Nullable error) {
        [self.collectionView.refreshControl endRefreshing];
        if (error) {
            NSLog(@"Failed getting feed. %@", error);
            return;
        }
        NSMutableArray *gifs = [self.gifList mutableCopy];
        for (GiphyImage *gif in results) {
            [gifs addObject:gif];
        }
        self.gifList = gifs;
        [self.collectionView reloadData];
    }];
}

- (void)refreshControlTriggered {
    if ([self.searchBar.text isEqualToString:@""]) {
        [self loadPage];
    } else {
        [self searchForGifs:self.searchBar.text];
    }
}

-(void)searchForGifs:(NSString *)searchText {
    [self.collectionView.refreshControl beginRefreshing];
    
    [[giphyService sharedService] getFirstPageWithSearchQueryIfNeeded:searchText withBlock:^(NSArray<GiphyImage *> * _Nullable results, NSError * _Nullable error) {
        [self.collectionView.refreshControl endRefreshing];
        if (error) {
            NSLog(@"Failed getting search results. %@", error);
            return;
        }
        self.gifList = results;
        [self.collectionView reloadData];
    }];
}

-(void)dismissKeyboard {
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - UICollectionViewDelegate

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

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gifList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GiphyImage *gif = self.gifList[indexPath.row];
    GifCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[GifCell cellIdentifier] forIndexPath:indexPath];
    [cell updateData:gif];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.gifList.count - 1) {
        NSLog(@"last cell appeared");
        NSString *offset = [NSString stringWithFormat:@"%i", (int)self.gifList.count];
        [self loadNextPage:offset withSearchTextIfNeeded:self.searchBar.text];
    }
}

#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadSearch) object:nil];
    [self performSelector:@selector(reloadSearch) withObject:nil afterDelay:0.5];
}

-(void)reloadSearch {
    [self searchForGifs:self.searchBar.text];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
     [self searchForGifs:searchBar.text];
    if ([searchBar isFirstResponder]) {
        [searchBar resignFirstResponder];
    }
}

@end
