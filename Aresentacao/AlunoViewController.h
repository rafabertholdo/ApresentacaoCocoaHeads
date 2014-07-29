//
//  NovoAlunoViewController.h
//  Aresentacao
//
//  Created by Rafael Bertholdo on 7/27/14.
//  Copyright (c) 2014 Bertholdo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReloadDataDeletegate <NSObject>

@required
-(void)reloadData;

@end

@interface AlunoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtNomeAluno;
@property (weak, nonatomic) IBOutlet UISwitch *swtMatriculado;
@property (strong,nonatomic) id<ReloadDataDeletegate> reloadDelegate;
@property (weak, nonatomic) NSDictionary *aluno;
@end
