//
//  DDTutorialViewController.m
//  iTaskFamily
//
//  Created by Damien DELES on 23/12/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDTutorialViewController.h"
#import "DDSettingTableViewCell.h"

@interface DDTutorialViewController ()

@end

@implementation DDTutorialViewController

#pragma mark - Fonctions de bases

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _arrayTutorial = [NSArray arrayWithObjects:NSLocalizedString(@"TUTO1", nil), NSLocalizedString(@"TUTO2", nil), NSLocalizedString(@"TUTO3", nil), NSLocalizedString(@"TUTO4", nil), NSLocalizedString(@"TUTO5", nil), NSLocalizedString(@"TUTO6", nil), NSLocalizedString(@"TUTO7", nil), NSLocalizedString(@"TUTO8", nil), NSLocalizedString(@"TUTO9", nil), NSLocalizedString(@"TUTO10", nil), NSLocalizedString(@"TUTO11", nil), nil];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //On configure la scrollView et le page control
    [[self scrollViewTutorial] setDelegate:self];
    [self.scrollViewTutorial setPagingEnabled:true];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    //On récupère les infos du tutoriel
    _arrayTutorialInfo = [DDHelperController getTutorialForChapter:self.tutorialChapter];
    
    self.pageControlTutorial.numberOfPages = [self.arrayTutorialInfo count];
    self.pageControlTutorial.currentPage = 0;
    
    //On set la couleur du thème principal
    [self.labelTitreTableView setTextColor:[DDHelperController getMainTheme]];
    
    [self loadPageControl];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //On vide la scrollView
    [self clearScrollView];
}


#pragma mark - Fonctions du controller

//On ferme la vue de tutorial
- (IBAction)onPushButtonClose:(id)sender {
    [self.delegate closeTutorialView];
}

//On affiche ou non la tableView des chapitres
- (IBAction)onPushButtonList:(id)sender {
    if (self.viewTutorial.frame.origin.x == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.viewTutorial setFrame:CGRectMake(300, 0, self.viewTutorial.frame.size.width, self.viewTutorial.frame.size.height)];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.viewTutorial setFrame:CGRectMake(0, 0, self.viewTutorial.frame.size.width, self.viewTutorial.frame.size.height)];
        }];
    }
}

//On vide la scrollView
- (void)clearScrollView {
    for (UIView *subview in [self.scrollViewTutorial subviews]) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
}


#pragma mark UIPageControl et UIScrollViewDelegate fonctions

//On appelle la fonction pour rafraichir le page control et la scroll view
-(void)loadPageControl
{
    //On vide la scrollView
    [self clearScrollView];
    
    //On rempli la scrollView
    for (int i = 0; i < [self.arrayTutorialInfo count]; i++)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Tutorial%i-%i", self.tutorialChapter, i] ofType:@"png"];
        
        UIImageView *imageViewTutorial = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollViewTutorial.frame.size.width * (i), 0, self.scrollViewTutorial.frame.size.width, self.scrollViewTutorial.frame.size.height)];
        [imageViewTutorial setImage:[UIImage imageWithContentsOfFile:filePath]];
        [self.scrollViewTutorial addSubview:imageViewTutorial];
    }
    
    [self.labelDescription setText:[self.arrayTutorialInfo objectAtIndex:0]];
    [self.scrollViewTutorial setContentSize:CGSizeMake(self.scrollViewTutorial.frame.size.width * [self.arrayTutorialInfo count], self.scrollViewTutorial.frame.size.height)];
    [self.scrollViewTutorial setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollViewTutorial.frame.size.width;
    int page = floor((self.scrollViewTutorial.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControlTutorial.currentPage = page;
    [self.labelDescription setAlpha:1];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x <= (scrollView.contentSize.width - scrollView.frame.size.width) && scrollView.contentOffset.x > 0)
    {
        float alphaToChange = (cosf(2 * M_PI * fmod(self.scrollViewTutorial.contentOffset.x, scrollView.frame.size.width) / scrollView.frame.size.width) + 1) * 0.5;
        [self.labelDescription setAlpha:alphaToChange];
        
        int currentPage = floor((self.scrollViewTutorial.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
        
        [self.labelDescription setText:[self.arrayTutorialInfo objectAtIndex:currentPage]];
        
        self.pageControlTutorial.currentPage = currentPage;
    }
}


#pragma mark - TableView Delegate fonctions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayTutorial count];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableViewChapitre cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:COULEUR_CELL_SELECTED];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableViewChapitre cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:COULEUR_WHITE];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On récupère la cellule
    DDSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTutorial" forIndexPath:indexPath];
    
    [cell.labelTutorial setText:[self.arrayTutorial objectAtIndex:indexPath.row]];
    [cell.labelTutorial setBackgroundColor:COULEUR_TRANSPARENT];
    
    return cell;
}

@end
