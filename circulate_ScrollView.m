 //
//  circulate_ScrollView.m
//  circulate_ScrollView1
//
//  Created by bioongroup on 15/10/27.
//  Copyright © 2015年 ylk. All rights reserved.
//
#define VIEW_WEIGHT self.frame.size.width
#define SELF_VIEW_HEIGHT self.frame.size.height
#define MAX_INDEX (int)_imageArray.count
#import "Header.h"
#import "circulate_ScrollView.h"
#import "adver_UIImageView.h"
//#import "advertisement_model.h"
//#import "showWebViewController.h"
@interface circulate_ScrollView()
{
    adver_UIImageView *_leftImageview,*_centerImageview,*_rightImageview;//左中右view
    int _leftImageViewIndex,_centerImageviewIndex,_rightImageviewIndex;//ImageView索引
    NSInteger pagemaxIndex;
    NSTimer *_timer;
}
@end

@implementation circulate_ScrollView
//@synthesize urlArray=_urlArray;
-(instancetype)initWithFrame:(CGRect)frame withArray:(NSMutableArray*)imageArray andWithshareurlArray:(NSMutableArray*)shareurlArray{
    self=[super initWithFrame:frame];
    _imageArray =imageArray;
    self.urlArray = shareurlArray;
    NSLog(@"shareurl ---- %@",shareurlArray);
    pagemaxIndex = imageArray.count;
    if(_imageArray.count ==2){
        NSObject *obj1 =[[_imageArray objectAtIndex:0] copy];
        NSObject *obj2 =[[_imageArray objectAtIndex:1] copy];
        [_imageArray addObject:obj1];
        [_imageArray addObject:obj2];
        NSObject *obj3 =[[shareurlArray objectAtIndex:0] copy];
        NSObject *obj4 =[[shareurlArray objectAtIndex:1] copy];
        [shareurlArray addObject:obj3];
        [shareurlArray addObject:obj4];
        pagemaxIndex = 2;
    }else if(_imageArray.count ==1){
        NSObject *obj1 =[[_imageArray objectAtIndex:0] copy];
        [_imageArray addObject:obj1];
        [_imageArray addObject:obj1];
        NSObject *obj3 =[[shareurlArray objectAtIndex:0] copy];
        [shareurlArray addObject:obj3];
        [shareurlArray addObject:obj3];
    }
    self = [super initWithFrame:frame];
    if(self){
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,VIEW_WEIGHT, VIEW_WEIGHT)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(VIEW_WEIGHT*3, 0);
        _scrollView.contentOffset = CGPointMake(VIEW_WEIGHT, 0);
        if([imageArray count]>=3){//设置左中右imageView
            _leftImageview = [[adver_UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, SELF_VIEW_HEIGHT)];
            _centerImageview = [[adver_UIImageView alloc]initWithFrame:CGRectMake(VIEW_WEIGHT, 0, VIEW_WEIGHT, SELF_VIEW_HEIGHT)];
            _centerImageview.userInteractionEnabled = YES;
            _rightImageview = [[adver_UIImageView alloc]initWithFrame:CGRectMake(VIEW_WEIGHT*2, 0, VIEW_WEIGHT, SELF_VIEW_HEIGHT)];
            _leftImageViewIndex = MAX_INDEX-1;
            _centerImageviewIndex = 0;
            _rightImageviewIndex = 1;
                    
            _leftImageview.image = [_imageArray objectAtIndex:_leftImageViewIndex];
            _centerImageview.image = [_imageArray objectAtIndex:_centerImageviewIndex];
            _rightImageview.image = [_imageArray objectAtIndex:_rightImageviewIndex];
            [_scrollView addSubview:_leftImageview];
            [_scrollView addSubview:_centerImageview];
            [_scrollView addSubview:_rightImageview];
            //pageControl
            _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(VIEW_WEIGHT/4, SELF_VIEW_HEIGHT-20, VIEW_WEIGHT/2, 20)];
            _pageControl.numberOfPages = pagemaxIndex;
            _pageControl.pageIndicatorTintColor = RGBA(35, 131, 221, 1);
            _pageControl.currentPageIndicatorTintColor = RGBA(240, 240, 240, 1);
            
            //给centerview添加一个手势
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click_method:)];
            [_centerImageview addGestureRecognizer:tap];
        }
        _leftImageview.share_url_str = [shareurlArray objectAtIndex:0];
        _centerImageview.share_url_str = [shareurlArray objectAtIndex:1];
        _rightImageview.share_url_str = [shareurlArray objectAtIndex:2];
        [self addSubview:_scrollView];
        [self addSubview:_pageControl];
    }return self;
}
//手势方法
-(void)click_method:(UITapGestureRecognizer* )gesture{
//    adver_UIImageView *imageview = (adver_UIImageView*)gesture.view;
//    showWebViewController *showWebController = [[showWebViewController alloc]init];
//    showWebController.share_url = imageview.share_url_str;
    
//    [self.delegate jupm_htmlPage:showWebController];
    adver_UIImageView *imageview = (adver_UIImageView*)gesture.view;
    NSLog(@"url ----- %@",imageview.share_url_str);
    
    NSString *judnmentString  = [[imageview.share_url_str componentsSeparatedByString:@":"] firstObject];
    if([judnmentString isEqualToString:@"h5"]){
        //跳转h5
        
        NSString *str1 = [[imageview.share_url_str componentsSeparatedByString:@":"] objectAtIndex:1];
        NSString *str2 = [[imageview.share_url_str componentsSeparatedByString:@":"] objectAtIndex:2];
        NSString *h5url = [NSString stringWithFormat:@"%@:%@",str1,str2];
        NSLog(@"h5   -%@",h5url);
        [self.delegate ad_clickwithMethod:0 andID:h5url andIndex:@"" andShareImage:imageview];
    }else if([judnmentString isEqualToString:@"video"]){
        //跳转视频
        NSString *lesson_id = [[imageview.share_url_str componentsSeparatedByString:@":"] objectAtIndex:1];
        [self.delegate ad_clickwithMethod:1 andID:lesson_id andIndex:@"" andShareImage:imageview];

    }else if([judnmentString isEqualToString:@"series"]){
        //跳转系列视频
        NSString *lesson_id = [[imageview.share_url_str componentsSeparatedByString:@":"] objectAtIndex:1];
        [self.delegate ad_clickwithMethod:2 andID:lesson_id andIndex:@"系列课程" andShareImage:imageview];
    }
}

//ScrollviewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(_scrollView.contentOffset.x==2*VIEW_WEIGHT){//右滑
        [self set_Rightmove];//左滑
    }else if(_scrollView.contentOffset.x==0){//左滑
        [self set_Leftmove];//右滑
    }[self setImage];//重置图片
    _scrollView.contentOffset = CGPointMake(VIEW_WEIGHT, 0);//归位
    _pageControl.currentPage = _centerImageviewIndex;
}

-(void)setImage{//重置图片
    _leftImageview.image = [_imageArray objectAtIndex:_leftImageViewIndex];
    _centerImageview.image = [_imageArray objectAtIndex:_centerImageviewIndex];
    _rightImageview.image = [_imageArray objectAtIndex:_rightImageviewIndex];
    //重置url
#pragma mark - 重写
    //这里要重写
    _leftImageview.share_url_str = [_urlArray objectAtIndex:_leftImageViewIndex];
    _centerImageview.share_url_str = [_urlArray objectAtIndex:_centerImageviewIndex];
    _rightImageview.share_url_str = [_urlArray objectAtIndex:_rightImageviewIndex];
}

/**向右滑动后重置的方法*/
-(void)set_Rightmove{//右滑
    _leftImageViewIndex+=1;
    _centerImageviewIndex+=1;
    _rightImageviewIndex+=1;
    if(_leftImageViewIndex==MAX_INDEX){
        _leftImageViewIndex = 0;
    }else if(_centerImageviewIndex==MAX_INDEX){
        _centerImageviewIndex = 0;
    }else if(_rightImageviewIndex==MAX_INDEX){
        _rightImageviewIndex = 0;
    }
}
/**向左滑动后重置的方法*/
-(void)set_Leftmove{//左滑
    _leftImageViewIndex-=1;
    _centerImageviewIndex-=1;
    _rightImageviewIndex-=1;
    if(_leftImageViewIndex==-1){
        _leftImageViewIndex = MAX_INDEX-1;
    }else if(_centerImageviewIndex==-1){
        _centerImageviewIndex = MAX_INDEX-1;
    }else if(_rightImageviewIndex==-1){
        _rightImageviewIndex = MAX_INDEX-1;
    }
}

-(void)slide{
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset = CGPointMake(VIEW_WEIGHT*2, 0);
    } completion:^(BOOL finished){
        [self set_Rightmove];
        [self setImage];
        _scrollView.contentOffset = CGPointMake(VIEW_WEIGHT, 0);
        _pageControl.currentPage = _centerImageviewIndex%pagemaxIndex;
    }];
}

-(void)setTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(slide) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
//- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount{
//    NSLog(@"123");
//    return CGSizeMake(40, 40);
//}


@end
