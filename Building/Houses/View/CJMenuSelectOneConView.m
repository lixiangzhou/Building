//
//  CJMenuSelectOneConView.m
//  Building
//
//  Created by Macbook Pro on 2019/2/9.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "CJMenuSelectOneConView.h"
#import "CJMenuSelectOneConCell.h"

#define CJMenuSelectOneConCellHeight       49
#define CJMenuSelectOneConCellXibName                @"CJMenuSelectOneConCell"

@interface CJMenuSelectOneConView()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (nonatomic, strong) NSArray *leftTableViewArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;


@property (weak, nonatomic) IBOutlet UIView *blackView;
@end


@implementation CJMenuSelectOneConView

- (instancetype)init
{
    if (self = [super init]) {
//        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
//        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[UINib nibWithNibName:NSStringFromClass([CJMenuSelectOneConView class]) bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
         [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)commonInit
{
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.tableFooterView = [UIView new];
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackCoverViewTapAction:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    self.selectIdx = -1;
    //数据初始化
    self.leftTableViewArr = @[];
}

#pragma mark - Actions
//cover视图tap响应函数
- (void)blackCoverViewTapAction:(UITapGestureRecognizer *)tapGesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectOneConViewCoverViewTapActionSelfView:)]) {
        //NSLog(@"blackCoverViewTapAction:%ld", self.tag );

        [self.delegate selectOneConViewCoverViewTapActionSelfView:self];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.blackView]) {
        //NSLog(@"gestureRecognizer YES:%ld", self.tag );
        return YES;
    } else {
        //NSLog(@"gestureRecognizer NO:%ld", self.tag );
        return NO;
    }
}


#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"section :%ld", self.leftTableViewArr.count );

    return self.leftTableViewArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CJMenuSelectOneConCell * cell = [tableView dequeueReusableCellWithIdentifier:CJMenuSelectOneConCellXibName];
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:CJMenuSelectOneConCellXibName owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.titleLabel.text = self.leftTableViewArr[indexPath.row];
    
    BOOL selected = self.selectIdx == indexPath.row;
    cell.backgroundColor = selected ? [UIColor whiteColor] : UIColorFromHEX(0xF9F9F9);
    cell.titleLabel.textColor = selected ? UIColorFromHEX(0x73B8FD) : UIColorFromHEX(0x6e6e6e);
    //NSLog(@"section :%@", cell.titleLabel.text );

    //cell.titleLabel.textColor = UIColorFromHEX(0x73b8fd);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CJMenuSelectOneConCellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    self.selectIdx = row;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectOneConViewSelectRow:selfView:)]) {
        //NSLog(@"didSelectRowAtIndexPath");

        [self.delegate selectOneConViewSelectRow:row selfView:self];
    }
    
    [tableView reloadData];

}

- (void)selectIdx:(NSInteger)idx {
    self.selectIdx = idx;
}

- (void)reloadData {
    self.leftTableViewArr = @[];
    [self.leftTableView reloadData];
}

#pragma - getters and setters
- (NSArray *)leftTableViewArr{
    if ((_leftTableViewArr == nil) || ([_leftTableViewArr  isEqual: @[]])) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectOneConViewTableViewDatasSelfView:)]) {
            _leftTableViewArr = [self.delegate selectOneConViewTableViewDatasSelfView:self];
            self.tableViewHeight.constant = _leftTableViewArr.count * CJMenuSelectOneConCellHeight;
        }
    }
    
    return _leftTableViewArr;
}

#pragma mark - Private

@end
