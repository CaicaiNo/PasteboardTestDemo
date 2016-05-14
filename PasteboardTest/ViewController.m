//
//  ViewController.m
//  PasteboardTest
//
//  Created by tangmi on 16/5/14.
//  Copyright © 2016年 simply. All rights reserved.
//

#import "ViewController.h"
#import "PasteboardTool.h"
@interface ViewController ()

@property (nonatomic,strong) PasteboardTool *tool;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tool = [[PasteboardTool alloc]init];
    [self.tool initPasteboard:@"com.sheng.PasteboardTest"];
    
    self.textView.editable = NO;
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickSave:(id)sender {
    
//    [self.tool saveStr:self.textField.text forKey:@"text"];
    [self.tool saveDic:[NSDictionary dictionaryWithObject:self.textField.text forKey:@"textField"] forKey:@"text"];
    
}
- (IBAction)clickGet:(id)sender {
    
    if ([self.tool dataForKey:@"text"]) {
//        NSString *str = [self.tool dataForKey:@"text"];
//        self.textView.text = str;
        NSDictionary *dic = [self.tool dataForKey:@"text"];
        
        self.textView.text = [self.textView.text stringByAppendingString:[dic objectForKey:@"textField"]];
        self.textView.text = [self.textView.text stringByAppendingString:@"\n"];
        
    }
    
}
- (IBAction)clearButton:(id)sender {
    
    [self.tool clear];
    NSString *str = [self.tool dataForKey:@"text"];//因为清空时我置为string类型了，你们可以自己定义
    self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"clear后数据:%@",str]];
    self.textView.text = [self.textView.text stringByAppendingString:@"\n"];
}
+ (NSDictionary *)dictionaryByJson:(NSString *)json {
    if (json == nil) {
        return nil;
    }
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        NSLog(@"json解析失败:%@",error);
        return nil;
    }
    return dic;
}
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
@end
