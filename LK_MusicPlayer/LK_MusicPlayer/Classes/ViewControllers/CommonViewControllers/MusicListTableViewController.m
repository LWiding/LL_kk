//
//  MusicListTableViewController.m
//  LK_MusicPlayer
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "MusicListTableViewCell.h"
#import "MusicPlayViewController.h"
@interface MusicListTableViewController ()

@property(nonatomic ,strong)NSMutableArray * musicArray;

@end

@implementation MusicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册Xib
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicListTableViewCell" bundle:nil] forCellReuseIdentifier:@"musicCell"];
    //请求并刷新
   [[MusicManager shareInstance]requstAllDataDidFinish:^(NSMutableArray *dataArr) {
       self.musicArray=dataArr;//把传过来的数组赋给定义的属性数组方便下面使用
        [self.tableView reloadData];
        
   }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu",(unsigned long)_musicArray.count);
    
    return _musicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicCell" forIndexPath:indexPath];
    MusicModel * model=self.musicArray[indexPath.row];
    cell.model=model;
      return cell;
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 150;
}
//选中哪一行

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MusicPlayViewController * musicVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"musicVC"];
    
    MusicPlayViewController * musicVC=[MusicPlayViewController shareInstance];
    musicVC.index=indexPath.row;
    
    //[self presentViewController:musicVC animated:YES completion:nil];
    [self.navigationController pushViewController:musicVC animated:YES];
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
