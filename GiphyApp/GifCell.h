//
//  gifCell.h
//  GiphyApp
//
//  Created by Yuri V on 11/05/2017.
//  Copyright © 2017 Yuri V. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GiphyImage;

@interface GifCell : UICollectionViewCell

-(void)updateData:(GiphyImage *)gif;

+(NSString *)cellIdentifier;

@end
