//
//  QXTMineTableViewController.m
//  企信通
//
//  Created by 林柏参 on 14/8/2.
//  Copyright (c) 2014年 林柏参. All rights reserved.
//

#import "QXTMineTableViewController.h"
#import "QXTAppDelegate.h"
#import "QXTSetTableViewController.h"
#import "QXTAppDelegate.h"

@interface QXTMineTableViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImagerView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jidLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@end

@implementation QXTMineTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStyleDone target:self action:@selector(zhuxiao)];
    /**
     *  后端有接口 这里就简单了
     */
    _nickNameLabel.text = @"Rains";
    _jidLabel.text = xmppDelegate.xmppStream.myJID.bare;
    _orgNameLabel.text = @"IBM";
    _telLabel.text = @"13800138000";
    _emailLabel.text = @"sshare@qq.com";
}

/**
 *  注销
 */
- (void)zhuxiao
{
    [xmppDelegate logout];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.tag == 2) { // 选择照片
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"关闭" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        [action showInView:self.view];
    }else if (cell.tag == 0)    { // 跳转新控制器
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"QXTSetTableViewController" bundle:nil];
        QXTSetTableViewController *set = [sb instantiateInitialViewController];
        
        [cell.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UILabel *lable = (UILabel *)obj;
            
            if (lable.tag == 1) {
                set.setStr = lable.text;
            }else
            {
                set.setLable = lable;
            }
            
        }];
        
        [self.navigationController pushViewController:set animated:YES];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    
    UIImagePickerController *pciker = [[UIImagePickerController alloc]init];
    if (buttonIndex == 0) {
        pciker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if(buttonIndex == 1)
    {
        pciker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    pciker.delegate = self;
    pciker.allowsEditing = YES;
    
    [self presentViewController:pciker animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePicker代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    _headerImagerView.image = image;

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
