#language:pt
    Funcionalidade: site agnaldo
        Sendo um usuario
        Posso acessar o site do google 
        Para fazer uma pesquisa
    
    @PesquisaDesk
    Cenario: Pesquisar no google 
        Dado que estou no site google
        Quando pesquiso por:
            | Pesquisa | Agnaldo Vilariano |
        Então vejo aseguinte frase na tela:
        """
        Agnaldo Vilariano
        """
