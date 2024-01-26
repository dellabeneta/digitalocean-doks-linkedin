<br>
<img src="https://drive.google.com/uc?export=view&id=1dSpQ1n429WG4rvsh-xKG7gkwGoVTySF1" width="1000">
<br>

# K8S Project

Oi, tudo bem? Se você chegou até aqui, é porque está interessado em saber mais sobre o diagrama que viu no LinkedIn, né? Então, vamos lá!

A proposta é realizar o deploy de uma aplicação web simples, desenvolvida em Python + Flask, para dentro de um Cluster Kubernetes na Digital Ocean - aproveitando o serviço gerenciado DOKS. Essa aplicação tem a função de retornar o hostname do servidor para o qual a requisição web do cliente foi direcionada. No nosso contexto, o hostname não será de um servidor, propriamente, mas sim, do pod que respondeu a essa requisição.

Cada requisição será encaminhada para um pod diferente graças ao serviço de load balancer do Cluster. Isso garante a distribuição equitativa das requisições, otimizando o aproveitamento dos recursos e evitando sobrecarregar um pod específico. Vamos explorar juntos essa dinâmica de distribuição eficiente!


## O ambiente utilizado (5 itens)

Esse projeto foi realizado a partir do meu Host/PC, Linux Ubuntu 23.10 (Mantic Minotaur), com as seguintes ferramentas instaladas e configuradas conforme a necessidade.

Vou considerar que você possui um ambiente limpo, completamente limpo e listar como você deverá seguir. Como não sei se você já possui o Git instalado de configurado em seu micro, passarei também por ele.
Não é obrigatório, mas tente seguir a mesma ordem:

#### 1. git/github

Bem, como menciono sempre, tudo tem um começo. Vamos lá então! Você precisa ter o git instalado na sua máquina e claro, uma conta aqui no Github **(crie a sua,caso não tenha)**. Vou tentar explanar os passos.

Abra o terminal e execute o seguinte comando para instalar o Git:

    sudo apt update 
    sudo apt install git

Você pode verificar se a instalação foi bem-sucedida digitando o seguinte comando:

    git --version

Configure seu nome de usuário e endereço de e-mail para associar aos seus commits. Substitua "Seu Nome" e "seu.email@example.com" pelos seus próprios dados:

    git config --global user.name "Seu Nome"
    git config --global user.email "seu.email@example.com"

Para gerar uma chave SSH, use o seguinte comando:

    ssh-keygen -t rsa -b 4096 -C "seu.email@example.com"

Quando solicitado, pressione "Enter" para aceitar o local padrão para salvar a chave, eu indico deixar no local padrão, evitando ter que passar o path quando formos utilizar. Caso você você já possua chaves no path padrão ~/.ssh, faça backup antes.

Execute o seguinte comando para adicionar a chave SSH ao agente SSH (essa dica é de outro, já perdi muito tempo da minha vida por não conhecer esses passos):

    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa

Use o seguinte comando para copiar a chave SSH para a área de transferência:

    sudo apt install xclip
    xclip -sel clip < ~/.ssh/id_rsa.pub

#### Passo a passo para adicionar a Chave SSH no GitHub:

 1. Acesse o GitHub (https://github.com/) e faça login na sua conta. 
 2. No canto superior direito, clique na sua foto do perfil e selecione "Settings".
 3. No menu lateral esquerdo, clique em "SSH and GPG keys".
 4. Clique em "New SSH key" e cole a chave que você copiou anteriormente.
 5. Dê um nome descritivo à chave e clique em "Add SSH key".

Agora você configurou com sucesso o Git no seu Ubuntu e associou uma chave SSH à sua conta do GitHub. Você pode testar a conexão usando o comando:

    ssh -T git@github.com

Se tudo estiver configurado corretamente, você receberá uma mensagem de confirmação.
Parabéns!
>Ref.: [Documentação Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git/)

#### 2. docker

Vamos instalar o 'docker', que será necessário para criarmos a imagem da aplicação e enviá-la para seu registry dentro da Digital Ocean.

Abra seu terminal e apenas aproveite o script para instalação simples:

    curl -fsSL https://get.docker.com | bash
    
Como pós-instalação, utilize o usermod para que seu usuário possa rodar os comandos do Docker:

    sudo usermod -aG docker $USER
    
Você vai precisar logar novamente em seu Linux. Quando retornar, teste com o comando:

    docker version

Isso deve trazer algumas informações do Docker, atestando nossa instalação.

E isso!
> Ref.: [Documentação Docker](https://docs.docker.com/engine/install/ubuntu/)

#### 3. kubectl

Agora podemos instalar o 'kubectl', que será utilizado para efetuarmos manualmente o deployment da nossa aplicação web - que será a última etapa!

Ainda no seu terminal:

    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

Finalize com:

    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

Teste a instalação com o comando:

`kubectl version --client`

Pronto! 
>Ref.: [Documentação Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux/)

#### 4. terraform

Para nosso 'terraform', vamos seguir os passos em nosso terminal, primeiro:

    sudo apt update && sudo apt install -y gnupg software-properties-common

Agora vamos instalar a chave necessária:

    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

Adicione o repo oficial para download da ferramenta:

    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

E finalmente:

    sudo apt update
    sudo apt install terraform
   
Você pode verificar a instalação do 'terraform' com o comando:

    terraform --help

ou

    terraform -v

Foi!
>Ref.: [Documentação Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli/)

#### 5. doctl

Talvez essa seja a ferramenta mais estranha aqui em nosso setup. Eu também conheci há pouco tempo, trata-se de uma CLI da própria Digital Ocean. Ela irá nos ajudar bastante em algumas etapas que precisam de autenticação e validações com o provider cloud. Vamos la:

    sudo snap install doctl

Sim, eles disponibilizam (oficialmente) a instalação apenas via snap. Então, certifique-se de ter o snap rodando em seu Ubuntu.

Teste com o comando:

    doctl version

Quero aproveitar o assunto 'Digital Ocean' e lembrar que você deve criar sua conta neste provider, caso ainda não possua. Após isso, acesse o menu API e crie para você um 'Personal Access Token'. Salve esse valor em um local seguro e jamais o compartilhe de qualquer forma.

Por enquanto, ficamos por aqui! Por enquanto...
>Ref.: [Documentação DOCTL](https://www.digitalocean.com/community/tutorials/how-to-use-doctl-the-official-digitalocean-command-line-client-pt/)
>
>Uffa, fui!
