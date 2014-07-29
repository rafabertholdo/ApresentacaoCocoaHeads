//
//  NovoAlunoViewController.m
//  Aresentacao
//
//  Created by Rafael Bertholdo on 7/27/14.
//  Copyright (c) 2014 Bertholdo. All rights reserved.
//

#import "AlunoViewController.h"
#import "URLConnection.h"


@interface AlunoViewController ()

@end

@implementation AlunoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.aluno){
        self.txtNomeAluno.text = [self.aluno objectForKey:@"Nome"];
        self.swtMatriculado.on = [[self.aluno objectForKey:@"Matriculado"] intValue];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)salvarAluno:(id)sender {
    __weak AlunoViewController *weakSelf = self;
    if(!self.aluno)
    {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        
        NSDictionary *aluno = @{@"Id": uuid,
                                @"Nome": self.txtNomeAluno.text,
                                @"Matriculado": [NSNumber numberWithBool: self.swtMatriculado.isOn]};
        
        [URLConnection post:@"http://192.168.234.110/testecrud/api/alunos" withObject:aluno successBlock:nil errorBlock:nil completeBlock:^{
            [weakSelf.reloadDelegate reloadData];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    else
    {

//        COMO ERA FEITO
//        NSDictionary* aluno = [NSDictionary dictionaryWithObjectsAndKeys:
//                               [self.aluno objectForKey:@"Id"], @"Id",
//                               self.txtNomeAluno.text, @"Nome",
//                               [NSNumber numberWithBool: self.swtMatriculado.isOn], @"Matriculado",
//                               nil];
        
        NSDictionary *aluno = @{@"Id": self.aluno[@"Id"],
                                @"Nome": self.txtNomeAluno.text,
                                @"Matriculado": [NSNumber numberWithBool: self.swtMatriculado.isOn]};
        
        
        [URLConnection put:[NSString stringWithFormat:@"http://192.168.234.110/testecrud/api/alunos/%@", [self.aluno objectForKey:@"Id"]] withObject:aluno successBlock:nil errorBlock:nil
             completeBlock:^{
            [weakSelf.reloadDelegate reloadData];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}

@end
