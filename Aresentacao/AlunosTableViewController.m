//
//  AlunosTableViewController.m
//  Aresentacao
//
//  Created by Rafael Bertholdo on 7/27/14.
//  Copyright (c) 2014 Bertholdo. All rights reserved.
//

#import "AlunosTableViewController.h"
#import "URLConnection.h"
#import "EditarAlunoViewController.h"

@interface AlunosTableViewController ()
@property (strong,nonatomic) NSArray* alunos;
@property (weak, nonatomic) NSDictionary *alunoSelecionado;
@end

@implementation AlunosTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;

    [self reloadData];
}

-(void)reloadData
{
    //Evitar Memory Cicle
    __weak AlunosTableViewController *weakSelf = self;
    [URLConnection get:@"http://testecrudwebapi.elasticbeanstalk.com/api/alunos" successBlock:^(NSData *data, id jsonData) {
        weakSelf.alunos = jsonData;
        [weakSelf.tableView reloadData];
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
    } completeBlock:nil];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
//      COMO ERA FEITO
//        NSDictionary* aluno = [self.alunos objectAtIndex:indexPath.row];
//        NSString* _id = [aluno objectForKey:@"Id"];
        
        NSDictionary* aluno = self.alunos[indexPath.row];
        NSString* _id = aluno[@"Id"];
        
        //Evitar Memory Cicle
        __weak AlunosTableViewController *weakSelf = self;
        [URLConnection delete:[NSString stringWithFormat:@"http://testecrudwebapi.elasticbeanstalk.com/api/alunos/%@", _id] successBlock:^(NSData *data, id jsonData) {
            [weakSelf reloadData];
        } errorBlock:nil completeBlock:nil];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.alunos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary* aluno = [self.alunos objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [aluno objectForKey:@"Nome"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.alunoSelecionado = [self.alunos objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"editarAluno" sender:self];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AlunoViewController *teste = ((AlunoViewController*)segue.destinationViewController);
    teste.reloadDelegate = self;
    
    if([segue.identifier isEqualToString:@"editarAluno"])
    {
        teste.aluno = self.alunoSelecionado;
    }
}

@end
