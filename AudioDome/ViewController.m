//
//  ViewController.m
//  AudioDome
//
//  Created by 颜学宙 on 2020/4/13.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "ViewController.h"
#import "AdioFileController.h"
#import "AudioSystemSoundVCViewController.h"
#import "MediaPayerController.h"
#import "CustomPlayAudioVC.h"
#import "SpeechRecognitionVC.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *list;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _list=@[@"AduioFile",@"播放系统声音",@"MediaPayerFramework",@"音乐播放",@"语音识别"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    NSString *title=[_list objectAtIndex:indexPath.row];
    cell.textLabel.text=title;
    cell.textLabel.textColor=[UIColor blackColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc;
    if (indexPath.row==0) {
        vc=[[AdioFileController alloc]init];
    }else if(indexPath.row==1){
        vc=[[AudioSystemSoundVCViewController alloc]init];
    }else if(indexPath.row==2){
        vc=[[MediaPayerController alloc]init];
    }else if (indexPath.row==3){
        vc=[[CustomPlayAudioVC alloc]initWithNibName:@"CustomPlayAudioVC" bundle:nil];
    }else if(indexPath.row==4){
        vc=[[SpeechRecognitionVC alloc]initWithNibName:@"SpeechRecognitionVC" bundle:nil];
    }
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
