//
//  TJY_VisitSignViewController.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/2.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_VisitSignViewController.h"
#import "CMInputView.h"
#import "TJY_ImageCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TJY_HomePageViewModel.h"
@interface TJY_VisitSignViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *imagePicker;
}
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UILabel *signTime;
@property (weak, nonatomic) IBOutlet UILabel *addressTitle;
@property (strong, nonatomic)  CMInputView *inputView;
@property (weak, nonatomic) IBOutlet UILabel *companyTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray  *  dataArray ;
@end

@implementation TJY_VisitSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleView.titleLabel.text = @"拜访签到";
    [self  initNaviRightButton];
    [self  configUI];
}
-(void)initNaviRightButton{
    UIButton  *  btn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn  setTitleColor:ssRGBHex(0x0080ff) forState:UIControlStateNormal];
    [self.titleView  addSubview:btn];
    
    self.addressTitle.text =  self.addressP;
    self.signTime.text = self.currentTime;
    
    [btn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(self.titleView);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(44);
    }];
    [[btn  rac_signalForControlEvents:UIControlEventTouchUpInside]  subscribeNext:^(__kindof UIControl * _Nullable x) {
        TJY_HomePageViewModel  *  model = [TJY_HomePageViewModel  new];
        NSArray  *  array = @[@"",self.lng,self.lat,self.addressP, self.inputView.text,self.dataArray];
        RACTuple  *  tupe = [RACTuple  tupleWithObjects:array,nil];
        [[model.attendanceCommand  execute:tupe]  subscribeNext:^(NSDictionary * x) {
            [self  showHint:[x  objectForKey:@"msg"]];
            [self.navigationController  popViewControllerAnimated:YES];
        } error:^(NSError * _Nullable error) {
            
        }];
    }];
}
-(void)configUI{
    [self.textView  addSubview:self.inputView];
    
    
  
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TJY_ImageCollectionViewCell  *  cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"TJY_ImageCollectionViewCell" forIndexPath:indexPath];
    cell.imgView.image = self.dataArray[indexPath.item];
    return   cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.dataArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView  deselectItemAtIndexPath:indexPath animated:YES];
    GMLog("%ld....",indexPath.item);
    if (indexPath.item == (self.dataArray.count-1)) {
        [self   actionViewControllerShow];
    }
}
-(void)actionViewControllerShow{
    __weak typeof(self)  weakSelf=self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"立即拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf   cameraClicked:nil];
    } ]];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf  pictureClicked:nil];
    } ]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }]];
    //    alert.view.tintColor = [UIColor darkTextColor];
    [self presentViewController:alert animated:YES completion:nil];
}

//立即拍照
- (void)cameraClicked:(id)sender
{
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        //sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIAlertController  * alert = [UIAlertController  alertControllerWithTitle:@"" message:@"拍摄功能不可用" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    if (!imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
    }
    [imagePicker setSourceType:sourceType];
    [imagePicker setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
    
    [self presentViewController:imagePicker animated:YES completion:^{
        
        //判断相机访问权限
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied)
        {
            // 无权限
            [self showHint:@"您没有访问相机权限,请到设置->隐私->相机打开"];
            return;
        }
    }];
}
//从相册选择
- (void)pictureClicked:(id)sender
{
    if (!imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
    }
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }];
}

-(void)cancelCamera {
    if (imagePicker) {
        [imagePicker dismissViewControllerAnimated:YES completion:nil];
        imagePicker = nil;
    }
}

#pragma mark Camera View Delegate Methods
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    //缩小图
    
    image = [ImageServices imageCompressForSize:image targetSize:CGSizeMake(720*2, 388*2)];
    //将头像上传到服务端
    

    [self.dataArray  insertObject:image atIndex:self.dataArray.count-1];
    [self.collectionView  reloadData];
    [self.collectionView  scrollToItemAtIndexPath:[NSIndexPath  indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

#pragma   mark  ---  getter  method
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray  arrayWithObjects:[UIImage  imageNamed:@"add2"], nil];
    }
    return  _dataArray;
}
-(CMInputView *)inputView{
    if (!_inputView) {
        _inputView = [[CMInputView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W-30, self.textView.frame.size.height)];
        _inputView.font = [UIFont systemFontOfSize:18];
        _inputView.cornerRadius = 10;
        _inputView.placeholder = @"请填写拜访签到备注...";
        _inputView.placeholderColor =ssRGBHex(0x999999);
        _inputView.textColor = ssRGBHex(0x222222);
        _inputView.backgroundColor = ssRGBHex(0xeaeaea);
        //_inputView.placeholderFont = [UIFont systemFontOfSize:22];
        // 设置文本框最大行数
        /*   [_inputView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
         CGRect frame = _inputView.frame;
         frame.size.height = textHeight;
         _inputView.frame = frame;
         self.topViewContraintHeight.constant = textHeight;
         [self.view  layoutIfNeeded];
         }];*/
        _inputView.maxNumberOfLines = 4;
    }
    return  _inputView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
