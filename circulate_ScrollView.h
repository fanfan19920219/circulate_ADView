//
//  circulate_ScrollView.h
//  circulate_ScrollView1
//
//  Created by bioongroup on 15/10/27.
//  Copyright © 2015年 ylk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "protrol.h"
//advertisement
//advertisement
@protocol  ADVERTISEMENT_DELETAGE

@optional
//-(void)jupm_htmlPage:(showWebViewController*)webViewController;

@end
/*
*图片大于等于三张时候使用这个类
*/
@interface circulate_ScrollView : UIView<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSMutableArray *urlArray;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,assign)id <Ad_ClickDelegate> delegate;
//Method
-(instancetype)initWithFrame:(CGRect)frame withArray:(NSMutableArray*)imageArray andWithshareurlArray:(NSMutableArray*)shareurlArray;
-(void)setTimer;
//传入的数组里有不少于3个元素
@end
