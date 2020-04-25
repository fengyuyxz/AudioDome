//
//  MediaPayerController.m
//  AudioDome
//
//  Created by 颜学宙 on 2020/4/18.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "MediaPayerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface MediaPayerController ()<MPMediaPickerControllerDelegate>
@property(nonatomic,strong)MPMediaPickerController *musicVC;//取文件
@property(nonatomic,strong)MPMusicPlayerController *muiscPlayVc;//播放文件
@end

@implementation MediaPayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.musicVC=[[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeAnyAudio];//MPMediaTypeAnyAudio 任何音频
    self.musicVC.delegate=self;
    self.musicVC.prompt=@"请选择一首歌曲";
    self.view.backgroundColor=[UIColor whiteColor];
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"选择" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    but.frame=CGRectMake(50, 80, 100, 50);
    but.tag=1;
    [but addTarget:self action:@selector(butTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
//    self.muiscPlayVc=[[MPMusicPlayerController alloc]init];
}
#pragma mark -MPMediaPickerControllerDelegate
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    //[[[MPMusicPlayerController alloc]init] ] init方式不再可用
    self.muiscPlayVc=[MPMusicPlayerController applicationMusicPlayer];
    [self.muiscPlayVc setQueueWithItemCollection:mediaItemCollection];
    [self.muiscPlayVc play];
}
-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}
-(void)butTap:(UIButton *)but{
    [self presentViewController:self.musicVC animated:YES completion:nil];
}
@end
