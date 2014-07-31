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
#import "UIImage+MJ.h"

// 5.导航栏左右变分类
#import "UIBarButtonItem+MJ.h"

// 6.全局背景色
#define YYGlobalBg [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]]