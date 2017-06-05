//
//  giphyCollectionViewController.m
//  
//
//  Created by Yuri V on 11/05/2017.
//
//

#import "giphyCollectionViewController.h"
#import "gifCell.h"
#import "giphyService.h"
#import "GifImage.h"

@interface giphyCollectionViewController () 

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *gifList;

@end

@implementation giphyCollectionViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *vfl = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) collectionViewLayout:vfl];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView];
    
    self.gifList = [[NSArray alloc] init];
    
    [self.collectionView registerClass:[gifCell class] forCellWithReuseIdentifier:[gifCell cellIdentifier]];
    
    self.collectionView.refreshControl = [[UIRefreshControl alloc] init];
    [self.collectionView.refreshControl addTarget:self action:@selector(refreshControlTriggered:) forControlEvents:UIControlEventValueChanged];
    
    [self.collectionView addSubview:self.collectionView.refreshControl];
    
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self loadPage];
    
}


-(void)loadPage {
    [self.collectionView.refreshControl beginRefreshing];
    
    [[giphyService sharedService] getHomeGifs:^(NSArray <GifImage *> *list, NSError *error) {
        [self.collectionView.refreshControl endRefreshing];
        self.gifList = list;
        
        [self.collectionView reloadData];
        
        if (error) {
            NSLog(@"Failed getting feed. %@", error);
        }
    }];
    
    
}



- (void)refreshControlTriggered:(id)sender {
    [self loadPage];
}




-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GifImage *gif = self.gifList[indexPath.row];
    
    CGFloat cellWidth = self.view.frame.size.width/2 - 5;
    CGFloat cellHeight = [gifCell heightOfCell:cellWidth forGif:gif];
    
    return CGSizeMake(cellWidth, cellHeight);
    
    
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}




#pragma mark CollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gifList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GifImage *gif = self.gifList[indexPath.row];
    
    CGFloat cellWidth = self.view.frame.size.width/3;
    CGFloat cellHeight = [gifCell heightOfCell:cellWidth forGif:gif];
    
    gifCell *cell = [[gifCell alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:[gifCell cellIdentifier] forIndexPath:indexPath];
    
    [cell updateData:gif];
    
    return cell;
}




#pragma mark CollectionView Delegate

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/



- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
