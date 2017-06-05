//
//  gifCell.h
//  GiphyApp
//
//  Created by Yuri V on 11/05/2017.
//  Copyright © 2017 Yuri V. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GifImage;

@interface gifCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *gifImage;

-(void)updateData:(GifImage *)gif;

+(CGFloat)heightOfCell:(CGFloat)width forGif:(GifImage *)gif;


+(NSString *)cellIdentifier;

@end
