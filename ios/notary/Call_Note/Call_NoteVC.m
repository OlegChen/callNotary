//
//  Call_NoteVC.m
//  notary
//
//  Created by he on 15/4/23.
//  Copyright (c) 2015年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "Call_NoteVC.h"
#import "AppDelegate.h"
#import "NSString+TKUtilities.h"
#import "CardCell.h"
#import "SearchCoreManager.h"
#import "BaseView.h"
#import "AddressCache.h"

#import "Call_Note_sqliteTool.h"
#import "Call_Note_Model.h"
#import "Call_note_Cell.h"
#import "cell_BG_cell.h"

#import "Address_Sqlite_Tool.h"
#import "AddressCard.h"

@interface Call_NoteVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

- (void)handleBackButtonClick:(UIButton *)but;
- (void)handleRightButtonClick;
//- (UIButton *) handleRightButton:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth;
- (void)handleSetText:(NSString*)text onBackButton:(UIButton*)backButton;
- (void)handleKeyborad:(BOOL)isShow;
- (void)handleSortCards:(NSArray *)cards;
- (void)initAddressBook;
- (void)initSortTable;

- (void)handleFilterCard:(NSString *)text;
- (ABAddressBookRef)initABAddressBookRef;

//通话记录拨出 参数
@property (nonatomic ,copy) NSString *num;
@property (nonatomic ,copy) NSString *name;


@property (nonatomic ,strong) NSArray *modelArr;

//改后查询结果
@property (nonatomic ,strong)  NSArray *searchDataArr;



@end

@implementation Call_NoteVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        //self.title = @"地址簿";
        
        
        // Custom initialization
        //self.hidesBottomBarWhenPushed = YES;
        //       AppDelegate * delgate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //
        //        [delgate hiddenTab:YES];
        _selectedCount = 0;
        _listContent = [NSMutableArray new];
        _filteredListContent = [NSMutableArray new];
        self.searchByName = [[NSMutableArray alloc] init];
        self.searchByPhone = [[NSMutableArray alloc] init];
        self.cardDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}



- (ABAddressBookRef)initABAddressBookRef
{
    
    
    
    ////
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    ABAddressBookRef addressBooks = nil;
    
    if(version  >= 6.0f) {
        
        addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待用户许可
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks,
                                                 ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        
    }
    else if (version < 6.0f) {
        
        addressBooks = ABAddressBookCreate();
        
    }
    return addressBooks;
}
- (void)initAddressBook
{
    
    ABAddressBookRef addressBooks = [self initABAddressBookRef];
    
    NSMutableArray * addressBookTemp = [NSMutableArray array];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    for (NSInteger i = 0; i < nPeople; i++)
    {
        
        AddressCard * card = [[AddressCard alloc] init];
        
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = ( __bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        
        card.name = nameString;
        card.recordID = (int)ABRecordGetRecordID(person);
        card.rowSelected = NO;
        
        
        
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        
        
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++)
        {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        card.tel = [(__bridge NSString *)value telephoneWithReformat];
                        break;
                    }
                    case 1: {// Email
                        //                        card.email = ( __bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        
        [addressBookTemp addObject:card];
        //        [addressBook release];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
        
        NSArray * tels = nil;
        if (card.tel != nil) {
            tels = [NSArray arrayWithObject:card.tel];
        }
        
        [[SearchCoreManager share] AddContact:[NSNumber numberWithInteger:card.recordID] name:card.name phone:tels];
        [self.cardDic setObject:card forKey:[NSNumber numberWithInteger:card.recordID]];
    }//end for
    
    
    // Sort data
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (AddressCard *addressBook in addressBookTemp) {
        NSInteger sect = [theCollation sectionForObject:addressBook
                                collationStringSelector:@selector(name)];
        addressBook.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (AddressCard *addressBook in addressBookTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        [_listContent addObject:sortedSection];
    }
    
    
}

- (void)handleFilterCard:(NSString *)text
{
    ABAddressBookRef addressBooks = [self initABAddressBookRef];
    
    // 寻找名为“CC”的联系人
    NSArray * people = (__bridge NSArray *)ABAddressBookCopyPeopleWithName(addressBooks, CFSTR("CC"));
    
    if ((people != nil) && [people count]) {
        
    }
    
    [_contentTable reloadData];
    
}
- (void)initSortTable
{
    
#pragma 改了
    //    self.sortTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 400) style:UITableViewStylePlain];
    //    _sortTable.hidden = YES;
    //    [self.view addSubview:_sortTable];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"通话录音"];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    //分割线
    [self setExtraCellLineHidden:_contentTable];

    
#pragma - mark 数据库
    //self.modelArr = [Call_Note_sqliteTool cacheWithParameters];
    
//    
//    if (_isShowKeyBorad) {
//        
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"showBtnImage" object:nil userInfo:nil];
//        
//    }else{
//    
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidenBtnImage" object:nil userInfo:nil];
//    
//    }
    
    
//    self.navigationController.navigationBarHidden = YES;
    
    [MobClick beginLogPageView:@"通话录音"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isShowKeyBorad = YES;
    
    self.title = @"通话记录";
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0] , NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
                                  //（其他textAttributes属性包括：UITextAttributeFont字体；UITextAttributedTextColor文字颜色；UITextAttributeTextShadowColor文字阴影颜色；UITextAttributeTextShadowOffset偏移用于文本阴影）
    
#pragma - mark 通知接收
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCenterNews) name:@"pullKeyboard" object:nil];

    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    statusBarView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
#pragma - mark navbar 标题
    
//    NSMutableArray *arr = [NSMutableArray array];
//    
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 40)];
//    [btn setImage:[UIImage imageNamed:@"拨号选中"] forState:UIControlStateNormal];
//    [btn setTitle:@"拨号" forState:UIControlStateNormal];
//    [self.view addSubview:btn];
//    [arr addObject:btn];
//    
//    
//    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 40)];
//    [self.view addSubview:btn1];
//    
//    [arr addObject:btn1];
//    
//    NSArray *array = [NSArray arrayWithArray:arr];
//    
    //[self.navigationItem setLeftBarButtonItems:array];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    
    //    [self initAddressBook];
    AddressCache * addCache = [AddressCache sharedInstance];
    self.cardDic = addCache.cardDic;
    self.listContent = addCache.listContent;
    
    int addresscount = [addCache getAddressCount];
    NSLog(@"add=%d",addresscount);
    int contactPersonCount = [addCache contactPersonCount];
    NSLog(@"ddd=%d",contactPersonCount);
    
    if (contactPersonCount != addresscount){
        //如果地址簿有变化 （增加，减少）修改不会引起重新加载
        [addCache initAddressBook];
    }
    
    
    
    //    UIButton * customLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    //    customLeft.contentMode = UIViewContentModeLeft;
    //    customLeft.frame = CGRectMake(0, 0, 80, 40);
    ////    [customLeft addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [customLeft setImage:[UIImage imageNamed:@"通讯录选中"] forState:UIControlStateNormal];
    //    [customLeft setTitle:@"通讯录" forState:UIControlStateNormal];
    //
    //    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:customLeft];
    
    //    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    //
    //    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItem:@"拨号选中" higImageNmae:@"拨号选中" tager:nil action:nil frame:CGRectMake(0, 0, 65, 40) title:@"拨号"];
    //
    //    NSArray *arr = [NSArray arrayWithObjects:btn1 , btn2, nil];
    //
    //    [self.navigationItem setLeftBarButtonItems:arr];
    
//    UIButton * customRight = [UIButton buttonWithType:UIButtonTypeCustom];
//    customRight.frame = CGRectMake(0, 0, 60, 40);
//    [customRight addTarget:self action:@selector(handleRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    customRight.titleLabel.font = [UIFont systemFontOfSize:15];
//    [customRight setTitle:@"弹出键盘" forState:UIControlStateNormal];
//    [customRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    //[customRight setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
//
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:customRight];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
    
#pragma - mark 创建tableview

    
    _contentTable  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 49 - 64) style:UITableViewStylePlain];
    _contentTable.delegate = self;
    _contentTable.dataSource = self;
    [self.view addSubview:_contentTable];
    _search.delegate = self;
    
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) {    //检查是否是iOS6
        // ABAddressBookRef abRef = ABAddressBookCreateWithOptions(NULL, NULL);
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            //如果该应用从未申请过权限，申请权限
            NSLog(@"如果该应用从未申请过权限，申请权限");
            //ABAddressBookRequestAccessWithCompletion(abRef, ^(bool granted, CFErrorRef error) {
            //根据granted参数判断用户是否同意授予权限
            //});
        } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            //如果权限已经被授予
            NSLog(@"如果权限已经被授予");
            
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:NO forKey:@"firstLaunch"];
                
                
                if (IOS7_OR_LATER) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"        使用电话录音拨打电话                您的通话将会被录音" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    //                [_contentTable reloadData];
                    
                }else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"使用电话录音拨打电话                您的通话将会被录音" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    
                }
                
                
            }
            
            
        } else {
            //如果权限被收回，只能提醒用户去系统设置菜单中打开
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置->隐私->通信录打开权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
            NSLog(@"如果权限被收回，只能提醒用户去系统设置菜单中打开");
        }
    }
    
    //索引
    //self.contentTable.sectionIndexBackgroundColor = [UIColor grayColor];
    self.contentTable.sectionIndexColor = [UIColor grayColor];
    
#pragma - mark  searchbar cancleBtn
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextShadowOffset,nil] forState:UIControlStateNormal];
    
    
#pragma  - mark 记录 表
    
    [Call_Note_sqliteTool setupSqlite];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCallNote) name:@"show_call_note" object:nil];//
    
    //keyboard 弹出
    [self handleKeyborad:YES];
    
    
}

- (void)showCallNote{
    
    _isFilter = NO;
    
    [_contentTable reloadData];
    
}

- (void)receiveCenterNews{

    [self handleRightButtonClick];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma handleMethods
//- (UIButton *) handleRightButton:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth
//{
//
//    UIImage* buttonImage = [backButtonImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
//    UIImage* buttonHighlightImage = [backButtonHighlightImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
//
//
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//    button.titleLabel.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0];
//    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
//    button.titleLabel.shadowColor = [UIColor darkGrayColor];
//
//    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
//
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, 6.0, 0, 3.0);
//
//    button.frame = CGRectMake(0, 0, 0, buttonImage.size.height);
//
//
//    [self handleSetText:self.navigationController.navigationItem.title onBackButton:button buttonCapWidth:capWidth];
//
//
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
//    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateSelected];
//
//
//    return button;
//}

- (void) handleSetText:(NSString*)text onBackButton:(UIButton*)backButton buttonCapWidth:(CGFloat)buttonCapWidth
{
    
    CGSize textSize = [text sizeWithFont:backButton.titleLabel.font];
    
    backButton.frame = CGRectMake(backButton.frame.origin.x,
                                  backButton.frame.origin.y,
                                  (textSize.width + (buttonCapWidth * 1.5)) > 160.0 ? 160.0 : (textSize.width + (buttonCapWidth * 1.5)),
                                  backButton.frame.size.height);
    
    
    [backButton setTitle:text forState:UIControlStateNormal];
}
- (void)handleBackButtonClick:(UIButton *)but
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)handleRightButtonClick
{
    
    [_search resignFirstResponder];
    
    if (!_isShowKeyBorad) {
        
        [self handleKeyborad:YES];
        _isShowKeyBorad = YES;
        
    }else {
        
        [self handleKeyborad:NO];
        _isShowKeyBorad = NO;
        
    }
    
}

#pragma - mark 键盘
- (void)handleKeyborad:(BOOL)isShow
{
    
    CGRect keyboradBounds ;
    
    
    if (nil == _keyboard) {
        
        NSArray * objs = [[NSBundle mainBundle] loadNibNamed:@"KeyboardView" owner:self options:nil];
        _keyboard = [objs lastObject];
        _keyboard.delegate = self;
        keyboradBounds = _keyboard.bounds;
//        if (IS_IPHONE_5) {
            _keyboard.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 49.5 , keyboradBounds.size.width, keyboradBounds.size.height);
//        }else {
//            _keyboard.frame = CGRectMake(0, 480, keyboradBounds.size.width, keyboradBounds.size.height);
//        }
        
       // _keyboard.backgroundColor = [UIColor colorWithRed:32.0f/255.0f green:32.0f/255.0f blue:32.0f/255.0f alpha:255];
        [self.view addSubview:_keyboard];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    
    if (isShow) {
        
//        if (IS_IPHONE_5) {
//            _keyboard.frame = CGRectMake(0,
//                                         240 - 49 + 64,
//                                         320,
//                                         280);
//        }else{
//
//            _keyboard.frame = CGRectMake(0,
//                                         148 -49 + 64,
//                                         320,
//                                         280);
//        }
        
        _keyboard.frame = CGRectMake(0,
                                     [UIScreen mainScreen].bounds.size.height - 49 - 64 - 280,
                                     [UIScreen mainScreen].bounds.size.width,
                                     280);

        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showBtnImage" object:nil userInfo:nil];
        

    }else {
        
//        if (IS_IPHONE_5){
//            _keyboard.frame = CGRectMake(0,
//                                         560,
//                                         320,
//                                         280);
//        }else {
//            _keyboard.frame = CGRectMake(0,
//                                         480,
//                                         320,
//                                         280);
//        }
        
        _keyboard.frame = CGRectMake(0,
                                     [UIScreen mainScreen].bounds.size.height,
                                     [UIScreen mainScreen].bounds.size.width,
                                     280);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hidenBtnImage" object:nil userInfo:nil];
        
        
    }
    [UIView commitAnimations];
}
- (void)notificationKeyboard
{
    [self handleRightButtonClick];
}

- (void)notificationKeyboardChangeNumber:(NSString *)number
{
//    [[SearchCoreManager share] Search:number searchArray:nil nameMatch:self.searchByName phoneMatch:self.searchByPhone];

    //查询
    
    self.searchDataArr = [Address_Sqlite_Tool getSearchDataWithStr:number];


    if (self.searchDataArr.count >= 1) {
        
        _isFilter = YES;
        [_contentTable reloadData];
    }
    
   
}

#pragma mark UITableViewDataSource UITableViewDelegate  methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    NSArray *arr = nil;
//    
//    if (arr == nil) {
//        
//        arr = [Call_Note_sqliteTool cacheWithParameters];
//
//    }
    
    
    if (_isFilter == NO && self.modelArr.count == 0) {
        
        _contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 270.0f;
    }else{
    
        if (_contentTable.separatorStyle != UITableViewCellSeparatorStyleSingleLine) {
            
            _contentTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

        }
        return 60.0f;
    }
}

#pragma - mark
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    
//    if (_isFilter) {
//        
//        return nil;
//    }else {
//        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
//                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
//    }
//    
//}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    if (_isFilter) {
//        return 0;
//    }else {
//        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
//        
//    }
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if (_isFilter) {
//        
//        return 1;
//    }else {
//        return [_listContent count];
//    }
//    
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (_isFilter) {
//        return nil;
//    }
//    else {
//        return [[_listContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
//    }
//    
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (_isFilter) {
//        return 0;
//    }else {
//        return [[_listContent objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
//    }
//}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //读表
    
    NSArray *arr = [Call_Note_sqliteTool cacheWithParameters];
    
    self.modelArr = arr;
    
    
    if (_isFilter) {
        
        return self.searchDataArr.count;
        
    }else {
        
        
        if (arr.count == 0) {
            
            return 1;
            
        }else{
            
            return arr.count;
            
        }
        
        
    }

    
//    if (_isFilter) {
//        
//        return [self.searchByName count] + [self.searchByPhone count];
//        
//    }else {
//        return [[_listContent objectAtIndex:section] count];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CardCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    if (cell == nil)
    {
        
        NSArray * objs = [[NSBundle mainBundle] loadNibNamed:@"CardCell" owner:self options:nil];
        cell = [objs lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.tag = indexPath.row + 100001;
    AddressCard * addressBook = nil;
    
    //头像
    NSString *headerImage = @"NewHeadImage";
    
    
    if (_isFilter) {
        
        
//        NSNumber *localID = nil;
//        NSMutableString *matchString = [NSMutableString string];
//        NSMutableArray *matchPos = [NSMutableArray array];
//        if (indexPath.row < [self.searchByName count]) {
//            localID = [self.searchByName objectAtIndex:indexPath.row];
//            
//            //姓名匹配 获取对应匹配的拼音串 及高亮位置
//            if ([_search.text length]) {
//                [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
//            }
//        } else {
//            localID = [self.searchByPhone objectAtIndex:indexPath.row-[self.searchByName count]];
//            NSMutableArray *matchPhones = [NSMutableArray array];
//            
//            //号码匹配 获取对应匹配的号码串 及高亮位置
//            if ([_search.text length]) {
//                [[SearchCoreManager share] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
//                [matchString appendString:[matchPhones objectAtIndex:0]];
//            }
//        }
        
//        addressBook = [self.cardDic objectForKey:localID];
        
        AddressCard *model = self.searchDataArr[indexPath.row];
        
        
        cell.name.text = model.name;
        
        cell.tel.text = model.tel;
        
        
        
        cell.headImageName = headerImage;
        
        
        return cell;
        
        
    }else {
        
        
        //cell.backgroundColor = [UIColor redColor];
        
        //NSArray *arr = [Call_Note_sqliteTool cacheWithParameters];
        
        if (self.modelArr.count != 0) {
            
            
            
            Call_note_Cell * cell = [tableView dequeueReusableCellWithIdentifier:@"default_1"];
            if (cell == nil)
            {
                
                NSArray * objs = [[NSBundle mainBundle] loadNibNamed:@"Call_note_Cell" owner:self options:nil];
                cell = [objs lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }

            int t_num = self.modelArr.count - ((int)indexPath.row + 1);
            
            NSLog(@"%d",t_num);
            
            Call_Note_Model * model = self.modelArr[t_num];
            
            
            
            if ([model.name isEqualToString:@""]) {
                
                cell.name.text = @"手动拨号";
            }else{
            
                cell.name.text = model.name;
            
            }
            
            cell.phoneNum.text = model.phoneNum;
            
            cell.time.text = model.call_time;
//            
//            cell.BG.hidden = YES;
//            cell.time.hidden = NO;
            
            
            cell.headImage.image = [UIImage imageNamed:@"NewHeadImage"];
            
            return cell;
            
            
        }else{
            
            //图片
            
            cell_BG_cell * cell = [tableView dequeueReusableCellWithIdentifier:@"default_2"];
            if (cell == nil)
            {
                
                NSArray * objs = [[NSBundle mainBundle] loadNibNamed:@"cell_BG_cell" owner:self options:nil];
                cell = [objs lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            
            
            return cell;
            
            
//            
//            cell.BG.hidden = NO;
//            
//            cell.name.hidden = YES;
//            
//            cell.tel.hidden = YES;
//            
//            cell.time.hidden = YES;
            
        }

        
        
        
//        
//        if (tableView == self.searchDisplayController.searchResultsTableView)
//            addressBook = (AddressCard *)[_filteredListContent objectAtIndex:indexPath.row];
//        else
//            addressBook = (AddressCard *)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//        
//        
//        if ([[addressBook.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
//            
//            cell.name.text = addressBook.name;
//            cell.tel.text = addressBook.tel;
//            cell.headImageName = headerImage;
//            
//        } else {
//            
//            cell.tel.text = addressBook.tel;
//            
//            cell.headImageName = headerImage;
//        }
        
    }//end else
    
    //return cell;
}

#pragma - mark cell滑动删除

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
     if (self.modelArr.count != 0 && _isFilter == NO) {
        
         return YES;
         
     }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *arr = [Call_Note_sqliteTool cacheWithParameters];
        
        Call_Note_Model *model = arr[(arr.count - 1) - indexPath.row];
        
//        int nn = ((self.modelArr.count - 1) - indexPath.row);
//        
//        NSLog(@"%d",nn);
        
        NSString *num = [NSString  stringWithFormat:@"%d",((arr.count - 1) - indexPath.row)];
        
        [Call_Note_sqliteTool deleteCall_NoteWithName:@"" phoneNum:@"" call_time:model.call_time t_id:num];
        
        // 删除 data source.
//        [_contentTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


//- (void) tableView:(UITableView *)tableView
//
//commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
//
// forRowAtIndexPath:(NSIndexPath *)indexPath 　　//对选中的Cell根据editingStyle进行操作
//
//{
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//        
//    {
//        
//        if (temp == 1)　　//将单元格从数据库1中删除
//            
//        {
//            
//            [[CommonDatainstance] delEntity:[[[CommonDatainstance] gainSelectResult] objectAtIndexPath:indexPath]];
//            
//            [[CommonDatainstance] saveDB];
//            
//            [[CommonDatainstance] refreshResult:[[CommonDatainstance] gainSelectResult]];
//            
//            NSArray *array = [[CommonDatainstance] gainSelectResult].fetchedObjects;
//            
//            array =  [[self changeArrayForm:array] copy];
//            
//            self.listData = array;
//            
//            [myTableView reloadData];
//            
//        }
//        
//        else if (temp == 2) ////将单元格从数据库2中删除
//            
//        {
//            
//            [[CommonDatainstance] delEntity:[[[CommonDatainstance] gainRecentResult] objectAtIndexPath:indexPath]];
//            
//            [[CommonDatainstance] saveDB];
//            
//            [[CommonDatainstance] refreshResult:[[CommonDatainstance] gainRecentResult]];
//            
//            NSArray *array = [[CommonDatainstance] gainRecentResult].fetchedObjects;
//            
//            array =  [[self changeArrayForm:array] copy];
//            
//            self.listData = array;
//            
//            [myTableView reloadData];
//            
//        }
//        
//    }
//    
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.modelArr.count != 0 && _isFilter == NO) {
        

    
    Call_Note_Model * model = self.modelArr[(self.modelArr.count - 1) - indexPath.row];
    //拨号
    [self CallWithNum:model.phoneNum name:model.name];
    
    self.name = model.name;
    self.num = model.phoneNum;
        
        
        
    }
//
//    [self tableView:self.contentTable accessoryButtonTappedForRowWithIndexPath:indexPath];
//    [self.contentTable deselectRowAtIndexPath:indexPath animated:YES];
    //    [self.navigationItem.rightBarButtonItem setEnabled:(_selectedCount > 0)];
    
    /*
     AddressCard * addressBook  = (AddressCard *)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
     
     CardCell * cell = (CardCell *)[tableView viewWithTag:indexPath.row + 100001];
     [cell call:addressBook.tel];
     */
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    AddressCard * addressBook = nil;
    
    
    addressBook = (AddressCard *)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    BOOL checked = !addressBook.rowSelected;
    addressBook.rowSelected = checked;
    
    // Enabled rightButtonItem
    if (checked) _selectedCount++;
    else _selectedCount--;
    [self.navigationItem.rightBarButtonItem setEnabled:(_selectedCount > 0 ? YES : NO)];
    
    UITableViewCell *cell =[self.contentTable cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton *)cell.accessoryView;
    [button setSelected:checked];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

#pragma mark UISearchBarDelegate methods

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [_search setShowsCancelButton:NO animated:YES];
    
    [_search resignFirstResponder];
    
    _isFilter = NO;
    [_contentTable reloadData];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [_search setShowsCancelButton:NO animated:YES];
    [_search resignFirstResponder];
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    [self handleKeyborad:NO];
    _isShowKeyBorad = NO;
    
    [_search setShowsCancelButton:YES animated:YES];
    
    for(id cc in [_search subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            break;
        }
    }
    
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    
    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:self.searchByName phoneMatch:self.searchByPhone];
    
    _isFilter = YES;
    [_contentTable reloadData];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    
    
//    _isShowKeyBorad = NO;
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.5];
//    
//    
//        if (IS_IPHONE_5){
//            _keyboard.frame = CGRectMake(0,
//                                         560,
//                                         320,
//                                         280);
//        }else {
//            _keyboard.frame = CGRectMake(0,
//                                         480,
//                                         320,
//                                         280);
//        }
//    
//    [UIView commitAnimations];

#pragma  - mark 滚动tableview 隐藏拨号键盘
    [_search resignFirstResponder];
    
    
    [self handleKeyborad:NO];
    _isShowKeyBorad = NO;
    

    

}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pullKeyboard" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"show_call_note" object:nil];

    

}

#pragma - mark cell选中 拨号

- (void)CallWithNum:(NSString *)num name:(NSString *)name{
    
    
    if ([num hasPrefix:@"0"]) {
        
        
        
        //记录 通话记录
        NSString *time = [Call_Note_sqliteTool getNowTime];
        [Call_Note_sqliteTool insertCall_NoteWithName:name phoneNum:num call_time:time];
        
        
        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@",Call_note_Cell.getTransferTel,num];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
    }
    else if (num.length <=9){
        
        if (IOS7_OR_LATER) {
            ZSYTextPopView*alertView = [[ZSYTextPopView alloc] initWithFrame:CGRectMake(0, 0, 250, 130)];
            alertView.titleName.text = @"请输入区号";
            alertView.maxLength=10;
            alertView.tag=1;
            alertView.myDelegate=self;
            [alertView show];
        }else{
            CustomAlertView * alert = [[CustomAlertView alloc] initWithAlertTitle:@"请输入区号"];
            alert.delegate = self;
            alert.maxLength = 4;
            
            [alert show];
        }
        
    }
    else{
        
        
        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@",Call_note_Cell.getTransferTel,num];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
        
        //记录 通话记录
        NSString *time = [Call_Note_sqliteTool getNowTime];
        [Call_Note_sqliteTool insertCall_NoteWithName:name phoneNum:num call_time:time];
        
        
        //NSLog(@"%@",self.phoneNum.text);
        
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex == alertView.firstOtherButtonIndex) {
        
        
        
    }else {
        
        CustomAlertView * alert = (CustomAlertView *)alertView;
        NSString * keyword = [alert getKeyWord];
        
        NSString * regex = @"0[0-9]{2,3}";
        NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isMatch = [pred evaluateWithObject:keyword];
        
        if (!isMatch) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入区号不正确" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
        
        
        //记录 通话记录
        NSString *time = [Call_Note_sqliteTool getNowTime];
        [Call_Note_sqliteTool insertCall_NoteWithName:self.name phoneNum:self.num call_time:time];
        
        
        NSString * number = [NSString stringWithFormat:@"tel://%@,,%@-%@",Call_note_Cell.getTransferTel,keyword,self.num];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
    }
}



- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
    
    
}


@end
