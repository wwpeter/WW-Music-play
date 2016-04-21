//
//  JHRefreshAmazingAniView.m
//  JHRefresh
//
//  Created by Jiahai on 14-9-17.
//  Copyright (c) 2014年 Jiahai. All rights reserved.
//

#import "JHRefreshAmazingAniView.h"
#import "JHRefreshMacro.h"
#import "UIView+JHExtension.h"

@implementation JHRefreshAmazingAniView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _aniImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__0001.png")]];
        _aniImgView.frame = CGRectMake(0, 0, 30, 30);
        _aniImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_aniImgView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _aniImgView.center = CGPointMake(self.jh_width*0.5, self.jh_height*0.5);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - JHRefreshViewDelegate

/**
 *  下拉时的动画
 */
- (void)refreshViewAniToBePulling
{
    
}
/**
 *  变成普通状态时的动画
 */
- (void)refreshViewAniToBeNormal
{
    [_aniImgView stopAnimating];
}
/**
 *  刷新开始
 */
- (void)refreshViewBeginRefreshing
{
    if(!_aniImgView.animationImages)
    {
        _aniImgView.animationImages = [NSArray arrayWithObjects:
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__0001@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__0002@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__0003@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__0004@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__0005@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__0006@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__0007@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__0008@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__0009@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00010@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00011@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00012@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00013@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00014@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00015@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00016@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00017@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00018@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00019@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00020@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00021@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00022@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00023@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00024@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00025@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00026@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00027@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00028@2x.png")],
                                       [UIImage imageNamed:JHRefreshSrcName(@"dropdown_anim__00029@2x.png")],
                                    
                                       nil];
        _aniImgView.animationDuration = 1;
        _aniImgView.animationRepeatCount = 0;
    }
    
    //刷新开始时，设置aniImageView的宽高
    _aniImgView.jh_width = _aniImgView.jh_height = JHRefreshViewHeight;
    [_aniImgView startAnimating];
}
/**
 *  刷新结束
 *
 *  @param result 刷新结果
 */
- (void)refreshViewEndRefreshing:(JHRefreshResult)result
{
    
}
/**
 *  拖拽到对应的位置
 *
 *  @param pos 位置，范围：1 ~ JHRefreshViewHeight
 */
- (void)refreshViewPullingToPosition:(NSInteger)pos
{
    if(pos == 0)
    {
        return;
    }
    CGPoint center = _aniImgView.center;
    
    _aniImgView.jh_width = _aniImgView.jh_height = 30.0;
    
    _aniImgView.center = center;
    
    NSString *name = [NSString stringWithFormat:@"dropdown_anim__000%d.png",(int)pos];
    _aniImgView.image = [UIImage imageNamed:JHRefreshSrcName(name)];
    
}


@end
