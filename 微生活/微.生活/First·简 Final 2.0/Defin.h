//
//  Defin.h
//  First·简
//
//  Created by yearwen on 15-6-11.
//  Copyright (c) 2015年 张耀文. All rights reserved.
//

#ifndef First___Defin_h
#define First___Defin_h



#define kScreenSize [UIScreen mainScreen].bounds.size
#import "LZXHelper.h"

//启动页面背景图片
//http://api2.pianke.me/pub/screenContent-Type:%20application/x-www-form-urlencoded?client=2
#define kDefaultScreen_URL @"http://api2.pianke.me/pub/screenContent-Type:%20application/x-www-form-urlencoded?client=2"

//简> 阅 界面接口
//http://api2.pianke.me/read/columns?client=2
#define kReadList_URL @"http://api2.pianke.me/read/columns?client=2"

//请求体sort=addtime&start=0&client=2&limit=10
//上拉加载更多 start +=10
#define kLastReadList_PosrBody @"sort=%@&start=%ld&client=2&limit=10"


//进入界面POST
#define kReadDetail_PostURL @"http://api2.pianke.me/read/%@"
#define kReadList_PostType @"columns_detail"
#define kReadLastTimeList @"latest"
// 请求体
#define kRedio_PostBody @"sort=%@&start=0&client=2&typeid=%@&limit=10"
//类型
//最后更新
#define kLastTime @"addtime"
//最热
#define kHotList @"hot"

//文章内容视图
#define kViewDetail @"http://api2.pianke.me/article/info"


/*
    进入列表详情界面
 阅读 -  早安故事(最新)页面
 post :http://api2.pianke.me/read/columns_detail
 
 Content-Type: application/x-www-form-urlencoded
 
 请求体:sort=addtime&start=0&client=2&typeid=1&limit=10
 上拉加载更多:  start  += 10;
 
	阅读 -  早安故事(最新)页面
 
 post :http://api2.pianke.me/read/columns_detail
 
 Content-Type: application/x-www-form-urlencoded
 
 请求体:sort=hot&start=0&client=2&typeid=1&limit=10
 
 */

//片刻  碎片心情
#define kChipFellings @"http://api2.pianke.me/timeline/list?start=%ld&addtime=%ld&client=2&limit=10"
//刷新方法  start += 10;


#define kChangeUIValue @"change"

#define kRotationDuration 8.0

/*
 片刻电台:
 刷新:
 http://api2.pianke.me/ting/radio?client=2;
 加载更多:
 http://api2.pianke.me/ting/radio_list?start=0&client=2&limit=9
 
 start= 9*n;
 */
//电台加载 刷新列表
#define kRedioRefresh_URL @"http://api2.pianke.me/ting/radio?client=2"
//电台 加载更多
#define kRedioMorePost_URL  @"http://api2.pianke.me/ting/radio_list"

//电台 详情界面
#define kRedioDetail_POSTURL @"http://api2.pianke.me/ting/radio_detail"
//


//回声小清新最热列表
#define kEchoHotChinnal @"http://echosystem.kibey.com/channel/info?id=24&list_order=hot&page=%ld"
//回声小清新 最新列表
#define kEchoNewsChinnal @"http://echosystem.kibey.com/channel/info?id=24&list_order=news&page=1"
//回声 歌曲详情界面
#define kEchoDetail @"http://echosystem.kibey.com/sound/info?sound_id=%@"
//ID 是 NSNumber 格式的

#define kUMengKey @"5587b61d67e58eadc5002287"

#endif
