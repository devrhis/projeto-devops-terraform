# README - Desafio DevOps

## Descrição do Projeto
Este projeto cria uma infraestrutura na AWS utilizando **Terraform** como ferramenta de IaC (Infraestrutura como Código). O objetivo é provisionar uma instância EC2 em uma VPC personalizada, garantir a segurança do acesso via SSH e automatizar a instalação do Nginx.

A configuração foi modularizada para seguir boas práticas de organização e manutenção do código, facilitando futuras alterações e escalabilidade.

## Estrutura do Projeto

. ├── main.tf ├── providers.tf ├── variables.tf ├── vpc.tf ├── security_groups.tf ├── ec2.tf ├── data_sources.tf ├── outputs.tf ├── user_data.sh


Cada arquivo `.tf` representa um módulo específico que gerencia uma parte da infraestrutura. Esta divisão torna o código mais organizado, facilita a leitura e a manutenção, além de permitir a reutilização em outros projetos.

## Módulos e Arquivos

1. **`providers.tf`**  
   Define o provedor da infraestrutura, no caso a **AWS**. A separação deste módulo facilita a alteração para outros provedores no futuro, como GCP ou Azure, sem modificar o restante da configuração.

2. **`variables.tf`**  
Contém todas as variáveis utilizadas na configuração, como nome do projeto, candidato e região. Isso permite parametrizar a infraestrutura, facilitando ajustes rápidos sem alterar o código principal.

3. **`vpc.tf`**  
Define a rede principal da infraestrutura, incluindo:

VPC
Subnet
Internet Gateway
Tabela de Roteamento e associação

Essa separação permite manter o foco na configuração de rede, essencial para ambientes bem organizados e escaláveis.

4. **`security_groups.tf`**  
Gerencia a segurança da instância EC2, definindo:

Regras de ingress (entrada), permitindo acesso via SSH.
Regras de egress (saída), permitindo todo o tráfego de saída.

A separação de regras de segurança facilita ajustes nas permissões e garante que as regras sejam gerenciadas de forma independente.

5. **`data_sources.tf`**  
Utilizado para buscar a AMI mais recente do Debian 12, garantindo que a instância EC2 seja provisionada com uma imagem atualizada.

6. **`ec2.sh`** 
Responsável pela criação da instância EC2, incluindo:

Configuração de armazenamento.
Chave SSH para acesso.
Associação à Subnet e ao Security Group.
Uso do script user_data.sh para inicialização automatizada.

7. **`user_data.sh`**  
Script para automatizar a atualização do servidor e instalação do Nginx.

8. **`outputs.tf`**  
Define as saídas da execução do Terraform, como:

A chave privada gerada para acesso via SSH.
O IP público da instância EC2 para acesso ao Nginx.

#    **Por que Modularizar?**
A modularização do código é uma prática recomendada por diversas razões:

Manutenção: Facilita alterações localizadas sem afetar o restante da configuração.
Reutilização: Permite que partes do código (como Security Groups ou VPC) sejam reutilizadas em outros projetos.
Colaboração: Em equipes, cada membro pode trabalhar em módulos específicos sem causar conflitos.
Escalabilidade: Torna o código mais adaptável para projetos maiores e mais complexos.

#    Instruções de Uso

# Inicializar o Terraform:
terraform init

# Validar a Configuração:
terraform validate

# Visualizar o Plano de Execução:
terraform plan

# Aplicar o Plano e Criar a Infraestrutura:
terraform apply

# Digite yes para confirmar a execução.

# Conexão SSH:

Digite terraform output private_key, copie o código rsa e crie um arquivo 
.pem, use o seguinte comando para conectar (no terminal): 
ssh -i path/to/your-key.pem username@ip-address

Ex: ssh -i ./key.pem admin@44.204.65.195

# Verifique status do Nginx:
systemctl status nginx

# Conclusão
Este projeto demonstra como utilizar o Terraform para provisionar uma infraestrutura básica na AWS de forma automatizada e segura. A modularização da configuração garante que o projeto seja fácil de manter e escalar, seguindo as melhores práticas recomendadas pela comunidade DevOps.

# Problemas Encontrados e Soluções Adotadas
Durante a criação da infraestrutura, encontrei dois problemas principais que precisei resolver para que o ambiente fosse provisionado corretamente:

1. Erro na Criação da VM (Security Group e VPC)
O primeiro problema ocorreu durante a criação da VM, especificamente na configuração do Security Group e da VPC. O erro informava que o Security Group não estava associado à VPC criada pelo Terraform.

Solução: Identifiquei que o código não estava referenciando corretamente o Security Group dentro da VPC personalizada (criada pelo Terraform). A linha original não especificava que o Security Group deveria estar associado à nova VPC. Para corrigir, alterei a configuração da instância EC2 da seguinte forma:

"vpc_security_group_ids = [aws_security_group.main_sg.id]"

Com essa alteração, a instância EC2 passou a usar o Security Group correto, vinculado à VPC personalizada criada pelo Terraform, e o erro foi resolvido.

2. Erro na Conexão com a VM (Problema com a Chave Privada)
O segundo problema aconteceu ao tentar me conectar à VM utilizando a chave privada gerada pelo Terraform no formato .pem. Para me conectar via PuTTY, precisei converter a chave .pem para .ppk utilizando o PuTTYgen. No entanto, ao tentar carregar a chave no PuTTYgen, recebi um erro informando que o arquivo era inválido.

Solução: Após inspecionar o arquivo no VSCode, percebi que ele havia sido salvo no formato UTF-16. O PuTTYgen não reconhecia esse formato, causando o erro. Para corrigir o problema, converti o arquivo para o formato UTF-8 e, em seguida, consegui convertê-lo para .ppk sem problemas. Depois disso, consegui me conectar à VM utilizando o PuTTY com sucesso. (Converti dentro do VSCode)



