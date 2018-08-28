//
//  ViewController.m
//  LFSpamCodeGenerator
//
//  Created by 李峰 on 2018/8/20.
//  Copyright © 2018年 DPG. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "SHHUD.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *wordsFromList;
@property (nonatomic, strong) NSArray *wordsFromTxt;

@end

int fileCount = 1000; //生成的文件个数

NSString *outPath = @"/Users/lifeng/Desktop/spamCode/newCode/";

NSString *publicHeader = @"PublicHeader";   //包含所有头文件的文件,可按需更改名称
NSString *publicCallClassName = @"HelloWorld";  //外面引用的类的名称,可按需更改

NSString *beforeClass = nil;
NSString *beforeClassPrefix = nil;
NSString *beforeClassSuffix = nil;



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(140, 250, 95, 45)];
    [button setTitle:@"生成废代码" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = .5f;
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void) buttonClicked
{
    [SHHUD HUDLoading:nil];
    while (fileCount > 0) {
        NSString *classname = [self getRandomClassName:@"LF_"];//类名前缀
        
        [self generatorSpamCodeFileWithClassName:classname];
        fileCount --;
    }
    [self generatorSpamCodeFileWithClassName:publicCallClassName]; //单独生成
    [SHHUD HUDInfo:@"废代码生成成功"];
}


/**
 获取随机类名
 */
- (NSString *) getRandomClassName:(NSString *)prefixStr
{
    NSString *className_MidString = [self getRandomStringFromArr:self.wordsFromList];
    NSString *className_randomStr = [self getRondomStringFromChar];
    NSString *className_SuffixStr = [self getClassNameSuffix];
    
    NSString *string = [NSString stringWithFormat:@"%@%@%@%@",prefixStr,className_MidString,className_randomStr,className_SuffixStr];
    return string;
}


/**
 从word_list中获取随机单词
 */
- (NSString *) getRandomString
{
    NSString *str = self.wordsFromList[(int)(arc4random() % self.wordsFromList.count)];
    str = [[str lowercaseString] capitalizedString];
    return str;
}

- (NSString *)getRandomStringFromArr:(NSArray *)words
{
    NSString *str = words[(int)(arc4random() % words.count)];
    str = [[str lowercaseString] capitalizedString];    //首字母大写
    return str;
}


/**
 从26个字母中随机生成两个字符的字符串
 */
- (NSString *)getRondomStringFromChar
{
    char data[2];
    for (int x = 0; x < 2; x++) {
        data[x] = (char)('A' + (arc4random_uniform(26)));
        NSLog(@"%c",data[x]);
    }
    
    NSString *randomStr = [[NSString alloc] initWithBytes:data length:2 encoding:NSUTF8StringEncoding];
    
    NSString *string = [NSString stringWithFormat:@"%@",randomStr];
    string = [[string lowercaseString] capitalizedString];
    return string;
}


/**
 类名后缀
 */
- (NSString *) getClassNameSuffix
{
    NSArray *suffixStrArray = @[@"View",@"ViewController",@"Controller",@"TableView",@"CollectionView",@"TableViewController",@"CollectionViewController",@"CollectionVIew",@"Progress",@"Delegate",@"Model",@"Controller",@"ViewController",@"Button",@"Label",@"Navigator",@"Contains",@"Configure",@"ViewController",@"BaseCell",@"TableViewCell",@"TextFiled",@"Controller",@"ViewController",@"ViewController",@"Table",@"PickerView",@"CustomView",@"Print",@"Moon",@"Sun",@"ViewController",@"LakersController",@"Lakers",@"Kobe",@"LBJ",@"LeBronJames",@"HomeView",@"AppDalegate",@"Sweetheart",@"Gorgeous",@"ViewController",@"Sophisticated",@"Renaissance",@"ViewController",@"Cosmopolitan",@"Bumblebee",@"Umbrella",@"Controller",@"Flabbergasted",@"Hippopotamus",@"ViewController",@"ViewController",@"Smashing",@"Loquacious",@"Smithereens",@"Hodgepodge",@"Shipshape",@"ViewController",@"ViewController",@"Explosion",@"Fuselage",@"Zing",@"Believe",@"Smithereens",@"Final",@"Galaxy",@"Butterfly",@"Rainbow",@"Destiny"];
    return suffixStrArray[(int)(arc4random() % suffixStrArray.count)];
}

/**
 生成有调用关系的垃圾代码
 */
- (void) generatorSpamCodeFileWithClassName:(NSString *)className
{
    [self createDirectory:outPath];
    NSString *importString = @"#import <Foundation/Foundation.h> \n";

    //创建一个包含所有.h的头文件
    NSString *allHeaderPath = [NSString stringWithFormat:@"%@%@.h",outPath,publicHeader];
    [self createFileWithPath:allHeaderPath Data:importString];
    
    NSString *classH = [NSString stringWithFormat:@"%@.h",className];
    NSString *importClassH = [NSString stringWithFormat:@"#import \"%@\" \n", classH];
    [self writeDataToEndFileWithPath:allHeaderPath AndData:importClassH];

    //初始化一个.h .m文件的内容
    NSMutableString *hFileMethodsString = [NSMutableString string];
    NSMutableString *mFileMethodsString = [NSMutableString string];
    
    NSSet *methodsSet = [self getMethodsSet];
    if ([className isEqualToString:publicCallClassName]) {
        //自定义公开方法的前半段
        methodsSet = [NSSet setWithObjects:@"mainMethodsCalledWith", nil];
    }
    
    NSString *beforeMethodPrefix = nil;
    NSString *beforeMethodSuffix = nil;
    NSUInteger index = 0; //正在写入第 index 个方法
    
    
    for (NSString *methodName in methodsSet) {
        //给.h文件添加注释 并拼接方法
        NSString *param1 = [self getRandomStringFromArr:self.wordsFromTxt];
        NSString *param2 = [self getRandomStringFromArr:self.wordsFromList];
        NSString *noteStr = getRandomNoteString();
        NSString *predicate = [self getRandomPredicate];
        [hFileMethodsString appendFormat:@"// %@ \n %@ (void)%@%@:(NSString *)%@ %@%@:(NSString *)%@;\n\n",noteStr, @"+", methodName, param1, param1.lowercaseString, predicate, param2, param2.lowercaseString];
        
        //给.m文件中添加注释并拼接方法
        [mFileMethodsString appendFormat:@"#pragma mark - %@ \n %@ (void)%@%@:(NSString *)%@ %@%@:(NSString *)%@\n {\n", noteStr, @"+", methodName, param1, param1.lowercaseString, predicate, param2, param2.lowercaseString];
        
        //方法内的代码
        [mFileMethodsString appendFormat:@"    NSLog(@\"function:%%s line:\", %@);\n\n", @"__FUNCTION__"];
        [mFileMethodsString appendFormat:@"    [%@ substringFromIndex:1];\n\n", param2.lowercaseString];
        [mFileMethodsString appendFormat:@"    [%@ isEqualToString:@\"%@\"];\n\n", param2.lowercaseString,param1.lowercaseString];
        [mFileMethodsString appendFormat:@"    NSLog(@\"%%@===%%@\", %@,%@);\n\n", param2.lowercaseString,[NSString stringWithFormat:@"@\"%@\"",param1.lowercaseString]];
        
        if (beforeClass && index == 0) {
            [mFileMethodsString appendFormat:@"     //调用%@  \n   [%@ %@:%@ %@:%@];", beforeClass, beforeClass, beforeClassPrefix, param1.lowercaseString, beforeClassSuffix, param2.lowercaseString];
            beforeClassSuffix = nil;
            beforeClassPrefix = nil;
        }
        if (beforeMethodPrefix) {
            [mFileMethodsString appendFormat:@"     //调用%@  \n   [self %@:%@ %@:%@];", beforeMethodPrefix, beforeMethodPrefix, param1.lowercaseString, beforeMethodSuffix, param2.lowercaseString];
        }
        
        [mFileMethodsString appendString:@"\n}\n\n"];
        beforeMethodPrefix = [NSString stringWithFormat:@"%@%@",methodName,param1];
        beforeMethodSuffix = [NSString stringWithFormat:@"%@%@",predicate,param2];
        
        if (index == methodsSet.count - 1) {
            beforeClassPrefix = beforeMethodPrefix;
            beforeClassSuffix = beforeMethodSuffix;
        }
        index ++;
        
    }
    
    
    
    
    NSString *fileName = [NSString stringWithFormat:@"%@.h",className];
    NSString *fileContent = [NSString stringWithFormat:kHClassFileTemplate,fileName,getCurrentDateString(),getCurrentYearString(),importString,className,hFileMethodsString];
    [fileContent writeToFile:[outPath stringByAppendingString:fileName] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSString *importClass = @"<Foundation/Foundation.h>";
    if (beforeClass) {
        importClass = [NSString stringWithFormat:@"\"%@\"",[beforeClass stringByAppendingString:@".h"]];
//            [SHHUD HUDSuccess:@"废代码生成成功"];
    }
    
    fileName = [NSString stringWithFormat:@"%@.m",className];
    fileContent = [NSString stringWithFormat:kMClassFileTemplate,fileName,getCurrentDateString(),getCurrentYearString(),className,importClass,className,mFileMethodsString];
    [fileContent writeToFile:[outPath stringByAppendingString:fileName] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    beforeClass = className;
}

///MARK: 获取方法集合
- (NSSet *) getMethodsSet
{
    int methodsCount = 10;  //  每个文件方法的个数
    NSMutableSet *set = [[NSMutableSet alloc] init];
    while (methodsCount > 0) {
        NSString *methodPrefix = [[self getRandomStringFromArr:self.wordsFromList] lowercaseString];
        NSString *brige1 = [self getRandomPredicate];
        NSString *methodName = [NSString stringWithFormat:@"%@%@",methodPrefix,brige1];
        [set addObject:methodName];
        methodsCount --;
    }
    return set;
}

- (NSString *) getRandomPredicate
{
    NSArray *arr = @[@"At",@"With",@"From",@"Between",@"Blong",@"To",@"In",@"On",@"For",@"Of",@"Over",@"By",@"Into",@"As",@"About",@"And"];
    return arr[(int)(arc4random() % arr.count)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 垃圾代码注释模版
static NSString *const kHClassFileTemplate = @"\
// \n\
// %@\n\
// Created by apple on %@\n\
// \n\
// Copyright © %@年 apple. All rights reserved.\n\
//\n\n\n\
%@\n\
@interface %@ : NSObject \n\
%@\n\
@end\n";
static NSString *const kMClassFileTemplate = @"\
// \n\
// %@\n\
// Created by apple on %@\n\
// \n\
// Copyright © %@年 apple. All rights reserved.\n\
//\n\n\n\
#import \"%@.h\"\n\
#import %@ \n\
@implementation %@ \n\
%@\n\
@end\n";

#pragma mark:获取当前时间string格式
NSString * getCurrentDateString(){
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =  @"yyyy/MM/dd";
    
    return [formatter stringFromDate:[NSDate date]];
}
#pragma mark:获取当前年
NSString * getCurrentYearString(){
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =  @"yyyy";
    
    return [formatter stringFromDate:[NSDate date]];
}

#pragma mark:生成随机注释字符串
NSString * getRandomNoteString(){
    
    NSString *string = @"登录，注册，测试";
    
    NSArray<NSString *> *strings = @[@"使用iOS原生来实现",@"监听web内容加载进度、是否加载完成",@"先创建配置对象，用于做一些配置",@"都使用默认的就可以了",@"在iOS上默认为NO，表示不能自动通过窗口打开",@"其实我们没有必要去创建它，因为它根本没有属性和方法",@"WKUserContentController是用于给JS注入对象的",@"传数据统一通过body传，可以是多种类型",@"只支持NSNumber, NSString, NSDate, NSArray,NSDictionary, and NSNull类型",@"通过JS与webview内容交互",@"当JS通过AppModel发送数据到iOS端时，会在代理中收到",@"可以注入多个名称（JS对象），用于区分功能",@"这里只是监听loading、title、estimatedProgress属性",@"链接跳转、接收响应、在导航开始、成功、失败等时要做些处理，就可以通过实现相关的代理方法",@"页面内容到达main frame时回调",@"导航完成时，会回调（也就是页面载入完成了）",@"对于HTTPS的都会触发此代理，如果不要求验证，传默认就行",@"9.0才能使用，web内容处理中断时会触发",@"这样一个 drawable 文件则可以通过它的名字识别",@"代码的注释经常被人忽略，其实注解有很多好处",@"方便使用，会提示注解说明",@"方便日后自己阅读代码",@"方便别人阅读自己代码",@"降低后期维护成本",@"可以快速生成开发文档",@"代码的注释方式五花八门",@"好的代码注解应该是这样的",@"可以使用[Option + 单击]查看注解",@"此方法只有头文件中属性/方法的注解才会提示",@"首先我们来看一下html部分的代码",@"首先要实例化一个WKWebView",@"这里如果没有JS调用OC的功能的话",@"需要配置WKWebViewConfiguration",@"对于WKWebView的实例化这里就不再赘述",@"我们在需要调用JS方法的位置加上下面代码",@"这样就能实现OC调用JS 方法",@"但是当我们运行的时候我们会发现",@"在前面的WKWebView使用之WKUIDelegate中",@"html的弹窗将不会再显示，那想显示弹窗，我们需要实现WKUIDelegate的代理方法",@"接下来实现代理方法",@"弹窗就会显示出来了，而且是iOS自己的原生弹窗",@"看一下iPhone X的模拟器样式",@"纯代码适配iPhone X脚底",@"纯代码的宽高比适配",@"UIBarButtonItem的适配",@"iPhone X的设计图",@"无线真机测试",@"真机地图适配",@"表示设置layer上面设置图片的的拉伸方式",@"表示当前layer设置的图片像素尺寸和试图大小的比例",@"layer上面显示的图片就是寄宿图片左上角四分之一",@"定义一个固定的边框和一个在图层上面可以拉伸的区域",@"需要设置阴影的时候，必须设置shadowOpacity的值是在0.0到1.0之间",@"当设置阴影和裁剪的时候，会把阴影的裁剪掉",@"shadowRadius控制着阴影的模糊度，当为0的时候，阴影和layer就会有一个明显的分界线，当值越来越大的时候，就会越来越自然和模糊",@"layer上面的触摸判断hitTest来判断",@"shadowPath设置阴影的图形",@"mask遮盖来设置图层显示的形状",@"layer三种拉伸过滤模式"];
    
    NSString *temp1 = strings[(int)(arc4random() % strings.count)];
    NSString *temp2 = strings[(int)(arc4random() % strings.count)];
    
    string = [temp1 stringByAppendingString:temp2];
    
    return string;
}

#pragma mark 文件夹相关
//创建文件夹
-(void) createDirectory:(NSString *)outDirectory{
    //创建目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:outDirectory isDirectory:NO]) {
        [fileManager createDirectoryAtPath:outDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

//创建文件
-(void) createFileWithPath:(NSString *)filePath
                      Data:(NSString *)initData{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath isDirectory:NO]) {
        //第一次创建写入importString
        [initData writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void) writeDataToEndFileWithPath:(NSString *)path AndData:(NSString *)data
{
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
    if (fileHandle == nil) {
        NSLog(@"can't open File at path:%@",path);
        return;
    }
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
}



- (NSArray *)wordsFromTxt
{
    if (!_wordsFromTxt) {
        NSString *wordsPath = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"txt"];
        NSError *error;
        NSString *string = [NSString stringWithContentsOfFile:wordsPath encoding:NSUTF8StringEncoding error:&error];
        if (error != nil) {
            NSLog(@"%@",error);
        }
        _wordsFromTxt = [string componentsSeparatedByString:@"\n"];
    }
    return _wordsFromTxt;
}

- (NSArray *)wordsFromList
{
    if (!_wordsFromList) {
        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"word_list" ofType:@"json"];
        NSError *error;
        NSData *data = [NSData dataWithContentsOfFile:filepath options:0 error:nil];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error != nil) {
            NSLog(@"%@",error);
            return nil;
        }
        _wordsFromList = jsonArray;
    }
    return _wordsFromList;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0, 0, 1, 1);  //图片尺寸
    
    UIGraphicsBeginImageContext(rect.size); //填充画笔
    
    CGContextRef context = UIGraphicsGetCurrentContext(); //根据所传颜色绘制
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect); //联系显示区域
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext(); // 得到图片信息
    
    UIGraphicsEndImageContext(); //消除画笔
    
    return image;
    
}

@end

