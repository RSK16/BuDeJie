//
//  BYTopicPictureView.m
//  BuDeJie
//
//  Created by biyong Huang on 2017/12/16.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYTopicPictureView.h"
#import "BYTopic.h"
#import <UIImageView+WebCache.h>
#import "BYSeeBigPictureViewController.h"

@interface BYTopicPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;

@end

@implementation BYTopicPictureView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;

    //[self.seeBigPictureButton addTarget:self action:@selector(seeBigPicture) forControlEvents:UIControlEventTouchUpInside];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}

/*
   查看大图
 */
- (void)seeBigPicture {
    BYSeeBigPictureViewController *seeBigVc = [[BYSeeBigPictureViewController alloc] init];
    seeBigVc.topic = _topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:seeBigVc animated:YES completion:nil];
}



- (void)setTopic:(BYTopic *)topic
{
    _topic = topic;
    
    // 设置图片
    self.placeholderView.hidden = NO;
    [self.imageView by_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholder:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        
        self.placeholderView.hidden = YES;
        
        // 处理超长图片的大小
        if (topic.isBigPicture) {
            CGFloat imageW = topic.middleFrame.size.width;
            CGFloat imageH = imageW * topic.height / topic.width;

            // 开启上下文
            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
            // 绘制图片到上下文中
            [self.imageView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            //self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();;
            
            // 关闭上下文
            UIGraphicsEndImageContext();
            
            self.imageView.image = newImage;
        }
    }];
    
    // gif
    self.gifView.hidden = !topic.is_gif;

    // 点击查看大图
    if (topic.isBigPicture) { // 超长图
        self.seeBigPictureButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    } else {
        self.seeBigPictureButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
}

@end
