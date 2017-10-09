//
//  AddressView.m
//  notary
//
//  Created by 肖 喆 on 13-3-7.
//  Copyright (c) 2013年 风雨者科技（北京）有限公司. All rights reserved.
//

#import "AddressView.h"
#import "AppDelegate.h"
#import "NSString+TKUtilities.h"
#import "CardCell.h"
#import "SearchCoreManager.h"
#import "BaseView.h"
#import "AddressCache.h"

#import "Address_Sqlite_Tool.h"

@interface AddressView ()<UIScrollViewDelegate>

- (void)handleBackButtonClick:(UIButton *)but;
- (void)handleRightButtonClick;
- (UIButton *) handleRightButton:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth;
- (void)handleSetText:(NSString*)text onBackButton:(UIButton*)backButton;
- (void)handleKeyborad:(BOOL)isShow;
- (void)handleSortCards:(NSArray *)cards;
- (void)initAddressBook;
- (void)initSortTable;

- (void)handleFilterCard:(NSString *)text;
- (ABAddressBookRef)initABAddressBookRef;

//查询完后的数据
@property (nonatomic ,strong) NSArray *searchDataArr;


@end

@implementation AddressView

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
        
        
        
        
//        [[SearchCoreManager share] AddContact:[NSNumber numberWithInteger:card.recordID] name:card.name phone:tels];
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
    
    
//    self.navigationController.navigationBarHidden = YES;
    
    [MobClick beginLogPageView:@"通话录音"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"电话簿";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0] , NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
    
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
    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItem:@"通讯录选中" higImageNmae:@"通讯录选中" tager:nil action:nil frame:CGRectMake(0, 0, 85, 40) title:@"通讯录"];
    //
    //    NSArray *arr = [NSArray arrayWithObjects:btn1 , btn2, nil];
    //
    //    [self.navigationItem setLeftBarButtonItems:arr];
    
    //    UIButton * customRight = [UIButton buttonWithType:UIButtonTypeCustom];
    //    customRight.frame = CGRectMake(0, 0, 60, 40);
    //    [customRight addTarget:self action:@selector(handleRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //    [customRight setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
    //
    //    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:customRight];
    //    self.navigationItem.rightBarButtonItem = rightButton;
    
    _search.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44);
    
//    _contentTable  = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_search.frame), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 44) style:UITableViewStylePlain];
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
            //            if (IOS7_OR_LATER) {
            //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"        使用电话录音拨打电话                您的通话将会被录音" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //                [alertView show];
            ////                [_contentTable reloadData];
            //
            //            }else {
            //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"使用移动公证拨打电话                您的通话将会被录音" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //                [alertView show];
            //
            //            }
            
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
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma handleMethods
- (UIButton *) handleRightButton:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth
{
    
    UIImage* buttonImage = [backButtonImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
    UIImage* buttonHighlightImage = [backButtonHighlightImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
    
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 6.0, 0, 3.0);
    
    button.frame = CGRectMake(0, 0, 0, buttonImage.size.height);
    
    
    [self handleSetText:self.navigationController.navigationItem.title onBackButton:button buttonCapWidth:capWidth];
    
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateSelected];
    
    
    return button;
}

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
        if (IS_IPHONE_5) {
            _keyboard.frame = CGRectMake(0, 560 , keyboradBounds.size.width, keyboradBounds.size.height);
        }else {
            _keyboard.frame = CGRectMake(0, 480, keyboradBounds.size.width, keyboradBounds.size.height);
        }
        
        _keyboard.backgroundColor = [UIColor colorWithRed:32.0f/255.0f green:32.0f/255.0f blue:32.0f/255.0f alpha:255];
        [self.view addSubview:_keyboard];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    
    if (isShow) {
        
        if (IS_IPHONE_5) {
            _keyboard.frame = CGRectMake(0,
                                         240 - 49,
                                         320,
                                         280);
        }else{
            
            _keyboard.frame = CGRectMake(0,
                                         148 -49,
                                         320,
                                         280);
        }
        
    }else {
        
        if (IS_IPHONE_5){
            _keyboard.frame = CGRectMake(0,
                                         560,
                                         320,
                                         280);
        }else {
            _keyboard.frame = CGRectMake(0,
                                         480,
                                         320,
                                         280);
        }
        
    }
    [UIView commitAnimations];
}
- (void)notificationKeyboard
{
    [self handleRightButtonClick];
}

- (void)notificationKeyboardChangeNumber:(NSString *)number
{
    [[SearchCoreManager share] Search:number searchArray:nil nameMatch:self.searchByName phoneMatch:self.searchByPhone];
    _isFilter = YES;
    [_contentTable reloadData];
}

#pragma mark UITableViewDataSource UITableViewDelegate  methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    if (_isFilter) {
        
        return nil;
    }else {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (_isFilter) {
        return 0;
    }else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isFilter) {
        
        return 1;
    }else {
        return [_listContent count];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_isFilter) {
        return nil;
    }
    else {
        return [[_listContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isFilter) {
        return 0;
    }else {
        return [[_listContent objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isFilter) {
        
        return self.searchDataArr.count;
        
    }else {
        return [[_listContent objectAtIndex:section] count];
    }
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
//        
//        addressBook = [self.cardDic objectForKey:localID];
//
        AddressCard *mode = self.searchDataArr[indexPath.row];
        
        cell.name.text = mode.name;
        
        cell.tel.text = mode.tel;
        
        //        cell.time.hidden = YES;
        //        cell.BG.hidden = YES;
        
        cell.headImageName = headerImage;
        
        
    }else {
        
        
        
        if (tableView == self.searchDisplayController.searchResultsTableView)
            addressBook = (AddressCard *)[_filteredListContent objectAtIndex:indexPath.row];
        else
            addressBook = (AddressCard *)[[_listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        
        if ([[addressBook.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
            
            cell.name.text = addressBook.name;
            cell.tel.text = addressBook.tel;
            cell.headImageName = headerImage;
            
            //            cell.time.hidden = YES;
            //            cell.BG.hidden = YES;
            
        } else {
            
            cell.tel.text = addressBook.tel;
            
            cell.headImageName = headerImage;
            
            //            cell.time.hidden = YES;
            //            cell.BG.hidden = YES;
        }
        
    }//end else
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self tableView:self.contentTable accessoryButtonTappedForRowWithIndexPath:indexPath];
    [self.contentTable deselectRowAtIndexPath:indexPath animated:YES];
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
    
//    [self handleKeyborad:NO];
//    _isShowKeyBorad = NO;
    
    //    [_search setShowsCancelButton:YES animated:YES];
    //
    //    for(id cc in [_search subviews])
    //    {
    //        if([cc isKindOfClass:[UIButton class]])
    //        {
    //            UIButton *btn = (UIButton *)cc;
    //            [btn setTitle:@"取消"  forState:UIControlStateNormal];
    //            break;
    //        }
    //    }
    
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
//    
//    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:self.searchByName phoneMatch:self.searchByPhone];
//
    //搜索
    if (searchText.length >= 1) {
        
        NSArray *arr = [Address_Sqlite_Tool getSearchDataWithStr:searchText];
        
        self.searchDataArr = arr;
        
        
        //NSArray *data = [Address_Sqlite_Tool cacheWithAddressParameters];
        
        
        if (arr.count >= 1) {
            
            _isFilter = YES;
            
            [_contentTable reloadData];
        }
        
        
        
    }else{
    
    
        _isFilter = NO;
        [_contentTable reloadData];

    
    }
    
    
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
    [self.view endEditing:YES];
    
    [self.search endEditing:YES];
    
}

@end
