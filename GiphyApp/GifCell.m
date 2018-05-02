//
//  gifCell.m
//  GiphyApp
//
//  Created by Yuri V on 11/05/2017.
//  Copyright © 2017 Yuri V. All rights reserved.
//

#import "GifCell.h"
#import "GiphyImage.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import <FLAnimatedImage/FLAnimatedImageView.h>

@interface GifCell()

@property (strong, nonatomic) FLAnimatedImageView *gifImage;

@end

@implementation GifCell

static NSString * const GifCellCellIdentifier = @"GifCellCellIdentifier";

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.gifImage];
    }
    return self;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.gifImage.image = nil;
}

-(void)updateData:(GiphyImage *)gif {
    [self.gifImage sd_setImageWithURL:gif.images.fixed_width_downsampled.url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *gifURL) {
        if (error) {
            NSLog(@"error loading gif\n%@", error);
            return;
        }
    }];
}

+(NSString *)cellIdentifier {
    return GifCellCellIdentifier;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.gifImage.frame = self.bounds;
}

-(FLAnimatedImageView *)gifImage {
    if (!_gifImage) {
        _gifImage = [[FLAnimatedImageView alloc] initWithFrame:self.frame];
    }
    return _gifImage;
}

@end
