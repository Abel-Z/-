//
//  ViewController.m
//  无限图片轮播
//
//  Created by 周abel on 16/3/9.
//  Copyright © 2016年 Abel. All rights reserved.
//

#import "ViewController.h"

#define w 375
#define h 667

// 图片的张数
#define imageCount 7

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myScroller;
@property (nonatomic, weak)UIImageView *centerImageView;
@property (nonatomic, weak)UIImageView *reusedimageView;

@end

@implementation ViewController


// 操作原理 :两张图片配合scrollView实现轮播
// 1. 设置scroll的contentSize为三倍的图片宽度
// 2. 创建两个imageView,用于显示图片
// 2. 核心, 根据contentOffset偏移量,切换图片;且永远显示中间那张图片

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.0 初始化数据
    
    // 开启分页功能
    self.myScroller.pagingEnabled = YES;
    
    // 隐藏显示条
    self.myScroller.showsVerticalScrollIndicator = NO;
    self.myScroller.showsHorizontalScrollIndicator = NO;
    
    // 关闭弹簧特效
    self.myScroller.bounces = NO;
    
    // 设置代理
    self.myScroller.delegate = self;
    
    // 设置contentSize
    self.myScroller.contentSize = CGSizeMake(3 *w, h);
    
    // 设置scrollView初始化显示的位置
    self.myScroller.contentOffset = CGPointMake(w, 0);
    
    // 指向中间图片
    UIImageView *centerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"00"]];
    centerImageView.frame = CGRectMake(w, 0, w, h);
    
    [self.myScroller addSubview:centerImageView];
    
    self.centerImageView = centerImageView;
    
    // 指向重复利用图片
    UIImageView *reusedimageView = [[UIImageView alloc] init];

    [self.myScroller addSubview:reusedimageView];
    
    self.reusedimageView = reusedimageView;
}


static int count = 1;
// 实现轮播
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    // 获取当前contentOffset
    CGFloat offset = scrollView.contentOffset.x;

    // 向左滚动
    if (offset>= w) {
        
        // 设置reusedimageView的位置
        self.reusedimageView.frame = CGRectMake(2*w, 0, w, h);
        
        /**
         *  此处可自己添加图片,但请注意命名方式,以便于加载图片
         */
        // 加载图片
        NSString *path = [NSString stringWithFormat:@"0%d", count];
        self.reusedimageView.image = [UIImage imageNamed:path];

        if ( 2 * w <= offset) {
            
            [self roller];
            
            // 最后一张图片时, 从头开始滚动
            if (++count > imageCount) {
                count = 0;
            }

        }
        
    } else {
        // 向右滚动
        
        // 设置reusedimageView的位置
        self.reusedimageView.frame = CGRectMake(0, 0, w, h);
        
            // 加载图片
            NSString *path = [NSString stringWithFormat:@"0%d", count];
            self.reusedimageView.image = [UIImage imageNamed:path];
        
            if (0 == offset) {

                [self roller];
                
                // 当回到第一张图片时,从最后再次滚动
                if (--count < 0) {
                    count = imageCount;
            }
                
        }
        
    }
}



// 滚动业务
- (void)roller {
    
        // 复位到原始偏移量
        self.myScroller.contentOffset = CGPointMake(w, 0);
    
        // 交换图片的位置
        CGRect frame = self.reusedimageView.frame;
        self.reusedimageView.frame = self.centerImageView.frame;
        self.centerImageView.frame = frame;
    
        // 交换指针
        UIImageView *imageViewTrans = self.centerImageView;
        self.centerImageView = self.reusedimageView;
        self.reusedimageView = imageViewTrans;
    
    }


@end
