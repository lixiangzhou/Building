//
//  LoginViewController.m
//  SmartHealth
//
//  Created by scj on 15/8/25.
//  Copyright (c) 2015年 certus. All rights reserved.
//

#import "LoginViewController.h"
#import "UserVC.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *activeField;
}

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *VerificationCodeBtn;//验证码
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VerificationCodeBtnWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *AccountView;
@property (weak, nonatomic) IBOutlet UIView *PasswordView;
    

@end

@implementation LoginViewController
#pragma mark - life cycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationItem setTitle:@"登录注册"];

    //ygz test
//    self.usernameField.text =   @"18270747102";
//    self.passwordField.text = @"465237";
//    [self login:self.loginBtn];
    //self.usernameField.text = @"15951708537";

    self.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: UIColorFromHEX(0x888888)}];
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: UIColorFromHEX(0x888888)}];
//    [self.usernameField setValue:UIColorFromHEX(0x888888) forKeyPath:@"_placeholderLabel.textColor"];
//    [self.passwordField setValue:UIColorFromHEX(0x888888) forKeyPath:@"_placeholderLabel.textColor"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.view endEditing:YES];
}

#pragma mark - action methods

//获取验证码按钮响应函数
- (IBAction)verificationCodeBtnClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    if (_usernameField.text.length == 0){
        [self showHint:@"请输入手机号"];
        return;
    }else if ([GlobalUtil checkMobileNumberTrue:_usernameField.text] == NO) {
        [self showHint:@"请输入正确手机号"];
        return;
    }
    [self startTime];
    [_VerificationCodeBtn setUserInteractionEnabled:NO];
    __weak typeof(self) weakSelf = self;
    [LoginNetworkService gainLoginSMSWithMobile:_usernameField.text success:^(NSString *user) {
        
    } failure:^(id response) {
        [weakSelf showHint:response];
    }];
}


//登录按钮响应函数
- (IBAction)login:(id)sender
{
    [self.view endEditing:YES];
    
    if ([_usernameField.text isEqualToString:@""] ) {
        [self showHint:self.view text:@"请输入手机号"];
        return;
    }
    
    if(self.usernameField.text.length != 11 )
    {
        [self showHint:self.view text:@"手机号输入不正确！"];
        return;
    }
    
    if([_passwordField.text isEqualToString:@""]) {
        [self showHint:self.view text:@"请输入验证码"];
        return;
    }
    
    

    [self.loginBtn setUserInteractionEnabled:NO];
    __weak typeof(self) weakSelf = self;
    [LoginNetworkService requestLogin:self.usernameField.text code:self.passwordField.text success:^(UserAndTokenModel *model) {
        [GlobalConfigClass shareMySingle].userAndTokenModel = model;
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(id response) {
        [weakSelf showHint:response];
        [weakSelf.loginBtn setUserInteractionEnabled:YES];
    }];

}
- (IBAction)infoButtonAction:(id)sender {
    UserVC *ac=[[UserVC alloc] init];
    [self.navigationController pushViewController:ac animated:YES];
}

#pragma mark - private
//- (void)configAppAfterLoginSuccess:(PersonStatusModel *)user{
    //更新全局配置信息
//    GlobalConfigClass *configer = [GlobalConfigClass shareMySingle];
//    configer.uid = user.uid;
//    configer.duid = user.duid;
//    configer.mobile = _usernameField.text;
//    if (_loginMode == LoginByUser) {
//        configer.password = _passwordField.text;
//    }
//    configer.imgUrl = user.imgUrl;
//    configer.realName = user.realName;
//    configer.userStatus = user.userStatus;
//    configer.isPushMsg = user.isPushMsg;
//    configer.isUploadCase = [user.isUploadCase integerValue];
//
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString * uidStr= [NSString stringWithFormat:@"%ld",(long)user.uid];
//    NSString * duidStr= [NSString stringWithFormat:@"%ld",(long)user.duid];
//    [defaults setObject:uidStr forKey:USER_ID];
//    [defaults setObject:duidStr forKey:USER_DUID];
//    [defaults setObject:configer.mobile forKey:USER_PHONENUMBER];
//    if (_loginMode == LoginByUser) {
//        [defaults setObject:configer.password forKey:USER_PASSWORD];
//    }
//    [defaults setObject:configer.imgUrl forKey:USER_HEADER_IMAGE_URL];
//    [defaults setObject:configer.realName forKey:USER_REALNAME];
//    [defaults setObject:configer.userStatus forKey:USER_USER_STATUS];
//    [defaults setObject:user.isUploadCase forKey:USER_UPLOAD_CASE_STATUS];
//    [defaults setObject:user.isPushMsg forKey:USER_IS_PUSH];
//
//    //注册极光推送的别名
//    NSString *aliasString = [NSString stringWithFormat:@"%@_%ld", _usernameField.text, (long)user.uid];
//    [JPUSHService setTags:nil alias:aliasString callbackSelector:nil object:self];
//}

// 跳转主界面
-(void)jumpToMainVC
{
//    [[LaunchViewController shareInstance] requestIsEnableFeedback];
}

// 开始倒计时
-(void)startTime{
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.VerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self setVertifiButtonuserInteractionEnabled:YES];
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.VerificationCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [self setVertifiButtonuserInteractionEnabled:NO];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)setVertifiButtonuserInteractionEnabled:(BOOL)isEnable {
    
    self.VerificationCodeBtn.enabled = isEnable;
    self.VerificationCodeBtn.userInteractionEnabled = isEnable;
    self.VerificationCodeBtn.backgroundColor = isEnable ? UIColorFromHEX(0xffffff) : UIColorFromHEX(0xffffff);
    UIColor *titleColor = isEnable ? UIColorFromHEX(0x515c6f) : UIColorFromHEX(0x515c6f);
    [self.VerificationCodeBtn setTitleColor:titleColor forState:UIControlStateNormal];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.usernameField]){
        int PHONE_MAX_CHARS = 11;
        NSMutableString *newtext = [NSMutableString stringWithString:textField.text];
        [newtext replaceCharactersInRange:range withString:string];
        
        BOOL resultBool = [newtext length] <= PHONE_MAX_CHARS;
        if (resultBool) {
            if([newtext length] != PHONE_MAX_CHARS){
                [self setVertifiButtonuserInteractionEnabled:NO];
            }else{
                [self setVertifiButtonuserInteractionEnabled:YES];
            }
        }
        return resultBool;
        
    } else if([textField isEqual:self.passwordField]){
        int SMS_PWD_MAX_CHARS = 6;
        NSMutableString *newtext = [NSMutableString stringWithString:textField.text];
        [newtext replaceCharactersInRange:range withString:string];
        
        BOOL resultBool = [newtext length] <= SMS_PWD_MAX_CHARS;
        if (resultBool && ([string length]>0)) {
            NSString *pattern = @"[a-zA-Z\\u0030-\\u0039]";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
            resultBool = [pred evaluateWithObject:string];
        }
        
        return resultBool;
    }else{
        return true;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if ([textField isEqual:self.usernameField]){
//        int PHONE_MAX_CHARS = 11;
//        NSMutableString *newtext = [NSMutableString stringWithString:textField.text];
//        if ([newtext length] != PHONE_MAX_CHARS) {
//            [self showHint:@"请输入正确手机号"];
//        } else{
//            if ([GlobalUtil checkMobileNumberTrue:newtext] == NO) {
//                [self showHint:@"请输入正确手机号"];
//            }
//        }
//    } else if([textField isEqual:self.passwordField]){
//        if (self.loginMode == LoginByUser) {
//            int PWD_MAX_CHARS = 20;
//            int PWD_MIN_CHARS = 6;
//            NSMutableString *newtext = [NSMutableString stringWithString:textField.text];
//            if ([newtext length] < PWD_MIN_CHARS || [newtext length] > PWD_MAX_CHARS) {
//                [self showHint:@"请输入6~20位密码"];
//            }
//        }else{
//        
//        }
//    }
//    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if ([textField isEqual:self.usernameField]) {
        [self setVertifiButtonuserInteractionEnabled:NO];
    }
    
    return YES;
}


@end
