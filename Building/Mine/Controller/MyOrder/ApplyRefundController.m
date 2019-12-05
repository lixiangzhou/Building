//
//  ApplyRefundController.m
//  Building
//
//  Created by 李向洲 on 2019/11/24.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "ApplyRefundController.h"
#import "OrderProductBaseInfoView.h"
#import "FSTextView.h"
#import "ApplyRefundStateView.h"
#import "TZImagePickerController.h"
#import <YBImageBrowser/YBImageBrowser.h>

@interface ApplyRefundController ()
@property (nonatomic, strong) OrderProductBaseInfoView *productView;
@property (nonatomic, strong) UITextField *stateField;
@property (nonatomic, strong) FSTextView *reasonView;
@property (nonatomic, strong) FSTextView *instructionView;
@property (nonatomic, strong) FSTextView *priceView;
@property (nonatomic, strong) UIView *uploadView;
@property (nonatomic, strong) ApplyRefundStateView *stateView;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedImgResults;
@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedImgs;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) NSArray *photos;
@end

@implementation ApplyRefundController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请退款";
    
    [self setUI];
    [self setData];
}

#pragma mark - UI
- (void)setUI {
    self.view.backgroundColor = BackGroundColor;
    self.stateView = [ApplyRefundStateView new];
    self.selectedAssets = [NSMutableArray new];
    self.selectedImgs = [NSMutableArray new];
    self.selectedImgResults = [NSMutableArray new];
    
    self.productView = [OrderProductBaseInfoView new];
    [self.view addSubview:self.productView];
    
    UIView *stateView = [self addStateView];
    
    NSArray *temp = [self addInputViewWithTitle:@"退款原因" placeholder:@"必选"];
    UIView *reasonView = temp[0];
    self.reasonView = temp[1];
    
    temp = [self addPriceView];
    UIView *priceView = temp[0];
    self.priceView = temp[1];
    self.priceView.keyboardType = UIKeyboardTypeNumberPad;
    [priceView addBottomLine];
    
    temp = [self addInputViewWithTitle:@"退款说明" placeholder:@"选填"];
    UIView *instructionView = temp[0];
    self.instructionView = temp[1];
    
    UIView *uploadView = [self addUploadView];
    
    UIButton *btn = [UIButton title:@"提交" titleColor:UIColorFromHEX(0xffffff) font:UIFontWithSize(15) target:self action:@selector(submit)];
    btn.backgroundColor = UIColorFromHEX(0x9ACCFF);
    [self.view addSubview:btn];
    
    MJWeakSelf
    self.stateView.stateBlock = ^(NSInteger state) {
        if (state == 1) {
            weakSelf.stateField.text = @"未收到货";
            weakSelf.priceView.userInteractionEnabled = NO;
            if (weakSelf.model) {
                weakSelf.priceView.text = weakSelf.model.price;
            } else if (weakSelf.refundModel) {
                weakSelf.priceView.text = weakSelf.refundModel.price;
            }
        } else if (state == 2) {
            weakSelf.priceView.userInteractionEnabled = YES;
            weakSelf.stateField.text = @"已收到货";
        }
    };
    
    [self.productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@124);
    }];
    
    [stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        CGFloat h = self.type == 1 ? 50 : 0;
        make.height.equalTo(@(h));
    }];
    
    [reasonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stateView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@70);
    }];
    
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(reasonView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [instructionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(instructionView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@120);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@45);
        make.bottom.equalTo(self.view);
    }];
}

- (UIView *)addStateView {
    UIView *stateView = [UIView new];
    stateView.backgroundColor = [UIColor whiteColor];
    [stateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateAction:)]];
    [self.view addSubview:stateView];
    
    [stateView addBottomLine];
    
    UILabel *label1 = [UILabel title:@"货物状态" txtColor:UIColorFromHEX(0x333333) font:UIFontWithSize(12)];
    label1.userInteractionEnabled = NO;
    [stateView addSubview:label1];
    
    self.stateField = [UITextField new];
    self.stateField.userInteractionEnabled = NO;
    self.stateField.textColor = UIColorFromHEX(0x333333);
    self.stateField.placeholder = @"请选择";
    self.stateField.textAlignment = NSTextAlignmentRight;
    self.stateField.font = UIFontWithSize(12);
    [stateView addSubview:self.stateField];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_more"]];
    [stateView addSubview:arrowView];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@17);
    }];
    
    [self.stateField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(stateView);
        make.right.equalTo(arrowView.mas_left).offset(-12);
        make.width.equalTo(@200);
    }];
    
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(stateView);
        make.right.equalTo(@-12);
    }];
    
    return stateView;
}

- (NSArray *)addInputViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *label1 = [UILabel title:title txtColor:UIColorFromHEX(0x333333) font:UIFontWithSize(12)];
    [view addSubview:label1];
    
    FSTextView *txtView = [FSTextView new];
    txtView.textColor = UIColorFromHEX(0x333333);
    txtView.placeholder = placeholder;
    txtView.font = UIFontWithSize(12);
//    txtView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [view addSubview:txtView];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@17);
    }];
    
    [txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.right.equalTo(@-12);
        make.left.equalTo(label1.mas_right).offset(15);
        make.bottom.equalTo(@-10);
    }];
    
    return @[view, txtView];
}

- (NSArray *)addPriceView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *label1 = [UILabel title:@"退款金额" txtColor:UIColorFromHEX(0x333333) font:UIFontWithSize(12)];
    [view addSubview:label1];
    
    UITextField *txtView = [UITextField new];
    txtView.textColor = UIColorFromHEX(0xFF9300);
    UILabel *prefix = [UILabel title:@"￥" txtColor:UIColorFromHEX(0xFF9300) font:UIFontWithSize(16)];
    [prefix sizeToFit];
    txtView.leftView = prefix;
    txtView.leftViewMode = UITextFieldViewModeAlways;
    txtView.font = UIFontWithSize(16);
    
    if (self.model) {
        txtView.text = self.model.price;
    } else if (self.refundModel) {
        txtView.text = self.refundModel.refundAmount;
    }
    
    if (self.type == 1) {
        txtView.userInteractionEnabled = NO;
    }
    
    [view addSubview:txtView];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@17);
    }];
    
    [txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.right.equalTo(@-12);
        make.left.equalTo(label1.mas_right).offset(15);
        make.bottom.equalTo(@-10);
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
        iconView.layer.masksToBounds = YES;
        iconView.layer.borderColor = UIColorFromHEX(0xececec).CGColor;
        iconView.hidden = i != 0;
        iconView.tag = i;
        iconView.userInteractionEnabled = YES;
        [iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgAction:)]];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 20, 14)];
        btn.hidden = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
        btn.backgroundColor = UIColorFromHEX(0xececec);
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

- (void)setData {
    if (self.model) {
        self.productView.model = self.model;
    } else if (self.refundModel) {
        self.productView.refundModel = self.refundModel;
    }
}

#pragma mark - Action
- (void)imgAction:(UITapGestureRecognizer *)tap {
    NSInteger idx = tap.view.tag;
    MJWeakSelf
    if (self.photos.count > 0 && idx < self.photos.count) {
        // 本地图片
        YBIBImageData *data0 = [YBIBImageData new];
        data0.image = ^UIImage * _Nullable{
            return weakSelf.photos[idx];
        };
        data0.projectiveView = tap.view;
        
        NSMutableArray *datas = [NSMutableArray array];
        [self.photos enumerateObjectsUsingBlock:^(NSString *_Nonnull img, NSUInteger idx, BOOL * _Nonnull stop) {
            // 本地图片
            YBIBImageData *data = [YBIBImageData new];
            data.image = ^UIImage * _Nullable{
                return weakSelf.photos[idx];
            };
            data.projectiveView = tap.view;
            [datas addObject:data];
        }];
        
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSourceArray = datas;
        browser.currentPage = idx;
        browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
        [browser show];

    } else {
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
}

- (void)stateAction:(UITapGestureRecognizer *)tap {
    [self.stateView show];
}

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    for (NSInteger i = 0; i < self.uploadView.subviews.count; i++) {
        UIImageView *view = self.uploadView.subviews[i];
        view.hidden = NO;
        
        [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = i >= photos.count;
        }];
        
        view.layer.borderWidth = 0;
        if (i < photos.count) {
            view.layer.borderWidth = 0.5;
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
    if (self.type == 1) {
        if (self.stateView.state == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择货物状态"];
            return;
        }
    }
    
    if (self.reasonView.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写退款原因"];
        return;
    }
    
    NSInteger value = [self.priceView.text integerValue];
    
    NSInteger price = self.model.price.integerValue;
    if (self.refundModel) {
        price = self.refundModel.price.integerValue;
    }
    
    if (value > price) {
        [SVProgressHUD showErrorWithStatus:@"不可超过订单金额"];
        return;
    }
    
    NSString *imgs = @"";
    if (self.selectedImgResults.count) {
        NSMutableArray *arr = [NSMutableArray new];
        for (NSInteger i = 0; i < self.selectedImgResults.count; i++) {
            [arr addObject:[NSString stringWithFormat:@"\"%@\"", self.selectedImgResults[i]]];
        }
        imgs = [arr componentsJoinedByString:@","];
        imgs = [NSString stringWithFormat:@"[%@]", imgs];
    } else {
        imgs = @"[]";
    }
    
    NSString *orderId = self.model.idStr;
    if (self.refundModel) {
        orderId = self.refundModel.orderId;
    }
    
    NSMutableDictionary *dict = dict = [@{
        @"orderId": orderId,
        @"refundAmount": @(value ?: 0),
        @"refundProof": imgs,
        @"refundReason": self.reasonView.text ?: @"",
        @"refundRemark": self.instructionView.text ?: @"",
        @"token": [GlobalConfigClass shareMySingle].userAndTokenModel.token ?: @""
    } mutableCopy];
    
    NSString *url = [NSString stringWithFormat:@"%@/order/refundGoodsAndMone", BasicUrl];
    
    if (self.type == 1) {
        dict[@"goodsStatus"] = @(self.stateView.state);
        url = [NSString stringWithFormat:@"%@/order/refundOnlyMoney", BasicUrl];
    }
    
    [QSNetworking postWithUrl:url params:dict success:^(id response) {
        if ([response[@"code"] integerValue] == 200) {
            if (self.model) {
                [self popToClazz:@"MyOrderVC"];
            } else if (self.refundModel) {
                [self popToClazz:@"MyRefundVC"];
            }
        } else {
            if ([response[@"msg"] length]) {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            } else {
                [SVProgressHUD showErrorWithStatus:@"提交失败"];
            }
        }
    } fail:^(NSError *error) {
    }];
}

@end
