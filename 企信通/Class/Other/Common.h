// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 2.获得RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 3.自定义Log
#ifdef DEBUG
#define LLog(...) NSLog(__VA_ARGS__)
#else
#define LLog(...)
#endif

// 4.图片处理分类
#import "UIImage+BC.h"

// 5.全局背景色
#define YYGlobalBg [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]]

// 6.导航栏左右按钮的分类
#import "UIBarButtonItem+BC.h"

// 7.单例
#import "Singleton.h"

// 8.设置日志颜色输出
#import "DDLog.h"
#import "DDTTYLogger.h"


#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_OFF;
#endif

// 9.指示器
#import "tooles.h"
