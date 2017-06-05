//
//  gifCell.m
//  GiphyApp
//
//  Created by Yuri V on 11/05/2017.
//  Copyright © 2017 Yuri V. All rights reserved.
//

#import "gifCell.h"
#import "GifImage.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"

@interface gifCell()




@end


@implementation gifCell




-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self.contentView addSubview:self.gifImage];
    }
    
    return self;
}



-(void)updateData:(GifImage *)gif {
    
    [self.gifImage sd_setImageWithURL:gif.url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *gifURL) {
        if (error) {
            NSLog(@"error loading gif\n%@", error);
            return;
        }
    }];
}

+(CGFloat)heightOfCell:(CGFloat)width forGif:(GifImage *)gif {
    CGFloat proportion =  gif.width / width;
    return gif.height/proportion;
    
}



+(NSString *)cellIdentifier {
    return @"gifCell";
}

-(UIImageView *)gifImage {
    if (!_gifImage) {
        _gifImage = [[UIImageView alloc] initWithFrame:self.frame];
    }
    return _gifImage;
}

@end
