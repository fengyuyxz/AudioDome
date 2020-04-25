//
//  AdioFileController.m
//  AudioDome
//
//  Created by 颜学宙 on 2020/4/13.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "AdioFileController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface AdioFileController ()

@end

@implementation AdioFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    NSString *filePath=[[NSBundle mainBundle]pathForResource:@"test1" ofType:@"mp3"];
    NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
    //打开
    AudioFileID audioFile;
    //0 表示只可读，和前一个参数是对应关系
    AudioFileOpenURL((__bridge CFURLRef)fileUrl, kAudioFileReadPermission, 0, &audioFile);
    
    //读取
    UInt32 dictionarySize=0;
    AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyInfoDictionary, &dictionarySize, 0);
    CFDictionaryRef dictionary;
    AudioFileGetProperty(audioFile, kAudioFilePropertyInfoDictionary, &dictionarySize, &dictionary);
    NSDictionary *audioDic=(__bridge NSDictionary *)dictionary;
    NSArray *keyList=[audioDic allKeys];
    for (int i=0; i<keyList.count; i++) {
        NSString *key=[keyList objectAtIndex:i];
        NSString *value=[audioDic objectForKey:key];
        NSLog(@"%@ = %@",key,value);
    }
    CFRetain(dictionary);
    AudioFileClose(audioFile);
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
