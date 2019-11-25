//
//  RefundController.m
//  Building
//
//  Created by 李向洲 on 2019/11/25.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "RefundController.h"
#import "OrderProductBaseInfoView.h"
#import "TZImagePickerController.h"

@interface RefundController ()
@property (nonatomic, strong) OrderProductBaseInfoView *productView;

@property (nonatomic, strong) UITextField *componyField;
@property (nonatomic, strong) UITextField *noField;

@property (nonatomic, strong) UIView *uploadView;

@property (nonatomic, strong) NSMutableArray<NSString *> *selectedImgResults;
@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedImgs;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@end

@implementation RefundController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"退货";
    
    [self setUI];
}

#pragma mark - UI
- (void)setUI {
    self.view.backgroundColor = BackGroundColor;
    
    self.selectedAssets = [NSMutableArray new];
    self.selectedImgs = [NSMutableArray new];
    self.selectedImgResults = [NSMutableArray new];
    
    self.productView = [OrderProductBaseInfoView new];
    self.productView.refundModel = self.model;
    [self.view addSubview:self.productView];
    
    NSArray *temp = [self addInputViewWithTitle:@"物流公司：" placeholder:@"必填"];
    UIView *companyView = temp[0];
    self.componyField = temp[1];
    [companyView addBottomLine];
    
    temp = [self addInputViewWithTitle:@"运单号：" placeholder:@"必填"];
    UIView *noView = temp[0];
    self.noField = temp[1];
    
    UIView *uploadView = [self addUploadView];
    
    UIButton *btn = [UIButton title:@"提交" titleColor:UIColorFromHEX(0xffffff) font:UIFontWithSize(15) target:self action:@selector(submit)];
    btn.backgroundColor = UIColorFromHEX(0x9ACCFF);
    [self.view addSubview:btn];
    
    [self.productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@124);
    }];
    
    [companyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(50));
    }];
    
    [noView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(companyView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@120);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@45);
        make.bottom.equalTo(self.view);
    }];
}

- (NSArray *)addInputViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *label1 = [UILabel title:title txtColor:UIColorFromHEX(0x333333) font:UIFontWithSize(12)];
    [view addSubview:label1];
    
    UITextField *txtView = [UITextField new];
    txtView.textColor = UIColorFromHEX(0x333333);
    txtView.placeholder = placeholder;
    txtView.font = UIFontWithSize(12);
    [view addSubview:txtView];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.equalTo(view);
    }];
    
    [txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.right.equalTo(@-12);
        make.left.equalTo(label1.mas_right).offset(15);
    }];
    
    return @[view, txtView];
}

- (UIView *)addUploadView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"上传凭证" attributes:@{NSForegroundColorAttributeName: UIColorFromHEX(0x333333)}];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"（最多三张）" attributes:@{NSForegroundColorAttributeName: UIColorFromHEX(0x999999)}]];
    UILabel *label1 = [UILabel title:nil txtColor:UIColorFromHEX(0x333333) font:UIFontWithSize(12)];
    label1.attributedText = attr;
    [view addSubview:label1];

    self.uploadView = [UIView new];
    [view addSubview:self.uploadView];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@10);
    }];
    
    CGFloat wh = 60;
    CGFloat x = 0;
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, wh, wh)];
        iconView.image = [UIImage imageNamed:@"pic_upload"];
        iconView.hidden = i != 0;
        iconView.tag = i;
        iconView.userInteractionEnabled = YES;
        [iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgAction:)]];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 20, 14)];
        btn.hidden = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [iconView addSubview:btn];
        
        [self.uploadView addSubview:iconView];
        
        
        x = CGRectGetMaxX(iconView.frame) + 10;
    }
    
    [self.uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(15);
        make.left.equalTo(@16);
        make.width.equalTo(@200);
        make.height.equalTo(@60);
    }];
    
    return view;
}

#pragma mark - Action
- (void)imgAction:(UITapGestureRecognizer *)tap {
        
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:nil];
    imagePickerVc.selectedAssets = self.selectedAssets;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self.selectedAssets removeAllObjects];
        [self.selectedAssets addObjectsFromArray:assets];
        
        [self.selectedImgs removeAllObjects];
        [self.selectedImgs addObjectsFromArray:photos];
        
        [self uploadImage:photos];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)setPhotos:(NSArray *)photos {
    for (NSInteger i = 0; i < self.uploadView.subviews.count; i++) {
        UIImageView *view = self.uploadView.subviews[i];
        view.hidden = NO;
        
        [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = i >= photos.count;
        }];
        
        if (i < photos.count) {
            view.image = photos[i];
        } else if (i == photos.count) {
            view.image = [UIImage imageNamed:@"pic_upload"];
        } else {
            view.hidden = YES;
        }
    }
}

- (void)deleteAction:(UIButton *)btn {
    [self.selectedImgs removeObjectAtIndex:btn.tag];
    [self.selectedAssets removeObjectAtIndex:btn.tag];
    [self.selectedImgResults removeObjectAtIndex:btn.tag];
    [self setPhotos:self.selectedImgs];
}

#pragma mark - Network
- (void)uploadImage:(NSArray *)images {
    NSString *url = [NSString stringWithFormat:@"%@/resource/file/upload", BasicUrl];
    
    dispatch_group_t group = dispatch_group_create();
    [self.selectedImgResults removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    for (NSInteger i = 0; i < images.count; i++) {
        dispatch_group_enter(group);
        [QSNetworking uploadWithImage:images[i] url:url filename:@"file" name:@"file" mimeType:@"image/png" parameters:nil headerParams:nil progress:nil success:^(id response) {
            if (response[@"result"]) {
                [self.selectedImgResults addObject:response[@"result"]];
            }
            dispatch_group_leave(group);
        } fail:^(NSError *error) {
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        [self setPhotos:images];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)submit {
    NSString *company = self.componyField.text ?: @"";
    NSString *no = self.noField.text ?: @"";
    if (company.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写物流公司"];
        return;
    }
    
    if (no.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写运单号"];
        return;
    }
    
    NSString *imgs = @"";
    if (self.selectedImgResults.count) {
        imgs = [self.selectedImgResults componentsJoinedByString:@","];
        imgs = [NSString stringWithFormat:@"[%@]", imgs];
    } else {
        imgs = @"[]";
    }
    
//    {
//        "logisticsCompany": "来咯摸摸",
//        "logisticsDocument": "226988545",
//        "logisticsProof": "[]",
//        "refundId": "211",
//        "token": "3f69a2ecbbada2fca77a6caa8b15fe2d"
//    }
    
    NSMutableDictionary *dict = dict = [@{
        @"logisticsCompany": company,
        @"logisticsDocument": no,
        @"logisticsProof": imgs,
        @"refundId": self.model.idStr,
        @"token": [GlobalConfigClass shareMySingle].userAndTokenModel.token ?: @""
    } mutableCopy];
    
    NSString *url = [NSString stringWithFormat:@"%@/order/returnGoods", BasicUrl];
    
    [QSNetworking postWithUrl:url params:dict success:^(id response) {
        if ([response[@"code"] integerValue] == 200) {
            [self popToClazz:@"MyRefundVC"];
        } else {
            if ([response[@"msg"] length]) {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
        }
    } fail:^(NSError *error) {
    }];
}

@end
