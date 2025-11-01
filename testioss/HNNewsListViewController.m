//
//  HNNewsListViewController.m
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import "HNNewsListViewController.h"
#import "HNAPIService.h"
#import "HNStory.h"
#import "HNNewsDetailViewController.h"
#import "HNStoryTableViewCell.h"
#import "HNEmptyStateView.h"
#import "HNThemeManager.h"

@interface HNNewsListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<HNStory *> *stories;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) HNEmptyStateView *emptyStateView;

@end

@implementation HNNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applyHackerTheme];
    [self setupUI];
    [self loadStories];
}

- (void)applyHackerTheme {
    HNThemeManager *themeManager = [HNThemeManager sharedManager];
    
    // Apply global theme
    [themeManager applyHackerTheme];
    
    // Apply view-specific theme
    self.view.backgroundColor = themeManager.primaryBackgroundColor;
    
    // Update title with hacker style
    self.title = @"🟢 HACKER://NEWS";
    
    // Set navigation appearance
    self.navigationController.navigationBar.backgroundColor = themeManager.primaryBackgroundColor;
    self.navigationController.navigationBar.barTintColor = themeManager.primaryBackgroundColor;
    
    // Force status bar to light content for dark theme
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupUI {
    HNThemeManager *themeManager = [HNThemeManager sharedManager];
    
    self.view.backgroundColor = themeManager.primaryBackgroundColor;
    
    // Set navigation appearance
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    
    // Table View
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = themeManager.primaryBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[HNStoryTableViewCell class] forCellReuseIdentifier:@"StoryCell"];
    [self.view addSubview:self.tableView];
    
    // Auto Layout
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    // Loading Indicator
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.loadingIndicator.color = themeManager.accentColor;
    self.loadingIndicator.center = self.view.center;
    self.loadingIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.loadingIndicator];
    
    // Add hacker effects to loading indicator
    [themeManager createHackerEffectsForView:self.loadingIndicator];
    
    // Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = themeManager.accentColor;
    self.refreshControl.backgroundColor = themeManager.secondaryBackgroundColor;
    [self.refreshControl addTarget:self action:@selector(refreshStories) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
}

- (void)loadStories {
    [self showEmptyState:HNEmptyStateTypeLoading];
    
    [[HNAPIService sharedService] fetchTopStorysWithCompletion:^(NSArray<HNStory *> * _Nullable stories, NSError * _Nullable error) {
        [self.refreshControl endRefreshing];
        
        if (error) {
            [self showEmptyState:HNEmptyStateTypeError];
            return;
        }
        
        if (stories.count == 0) {
            [self showEmptyState:HNEmptyStateTypeNoData];
        } else {
            [self hideEmptyState];
        }
        
        self.stories = stories;
        [self.tableView reloadData];
        
        // Animate cells appearing
        [self animateCellsAppearance];
    }];
}

- (void)refreshStories {
    [self loadStories];
}

- (void)showAlertWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"⚠️ Network Error" 
                                                                   message:error.localizedDescription 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"🔄 Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadStories];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:retryAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HNStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoryCell" forIndexPath:indexPath];
    
    HNStory *story = self.stories[indexPath.row];
    [cell configureWithStory:story];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Add haptic feedback
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [generator impactOccurred];
    
    HNStory *story = self.stories[indexPath.row];
    
    HNNewsDetailViewController *detailVC = [[HNNewsDetailViewController alloc] initWithStory:story];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (UIEdgeInsets)tableView:(UITableView *)tableView sectionInsetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.0;
}

#pragma mark - Empty State Management

- (void)showEmptyState:(HNEmptyStateType)type {
    if (!self.emptyStateView) {
        self.emptyStateView = [[HNEmptyStateView alloc] initWithFrame:self.view.bounds type:type];
        self.emptyStateView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.emptyStateView];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.emptyStateView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
            [self.emptyStateView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.emptyStateView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.emptyStateView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
        ]];
    }
    
    HNEmptyStateActionBlock action = nil;
    if (type == HNEmptyStateTypeError) {
        action = ^{
            [self loadStories];
        };
    }
    
    [self.emptyStateView configureForType:type withAction:action];
    self.emptyStateView.hidden = NO;
    self.tableView.hidden = YES;
}

- (void)hideEmptyState {
    self.emptyStateView.hidden = YES;
    self.tableView.hidden = NO;
}

- (void)animateCellsAppearance {
    HNThemeManager *themeManager = [HNThemeManager sharedManager];
    
    for (NSInteger i = 0; i < self.stories.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (cell) {
            // Start with cells off-screen and with glitch effect
            cell.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0);
            cell.alpha = 0;
            
            // Random color glitch effect
            if ([cell isKindOfClass:[HNStoryTableViewCell class]]) {
                HNStoryTableViewCell *storyCell = (HNStoryTableViewCell *)cell;
                storyCell.titleLabel.textColor = [themeManager randomHackerColor];
            }
            
            // Animate them in with hacker-style stagger and bounce
            [UIView animateWithDuration:0.8 
                                  delay:i * 0.03 
                 usingSpringWithDamping:0.6 
                  initialSpringVelocity:0.8 
                                options:UIViewAnimationOptionCurveEaseInOut 
                             animations:^{
                cell.transform = CGAffineTransformIdentity;
                cell.alpha = 1;
            } completion:^(BOOL finished) {
                // Add subtle glow animation after cell appears
                if ([cell isKindOfClass:[HNStoryTableViewCell class]]) {
                    HNStoryTableViewCell *storyCell = (HNStoryTableViewCell *)cell;
                    [storyCell.cardView.layer addAnimation:[themeManager hackerGlowAnimation] forKey:@"hackerGlow"];
                }
            }];
        }
    }
}

@end